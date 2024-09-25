// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract VotingPlatformSTV is Ownable, ReentrancyGuard {
    using Counters for Counters.Counter;

    struct Voter {
        address voterAddress;
        uint256[] choices; 
        bool hasVoted;
        bool isRegistered;
    }

    struct Candidate {
        string name;
        uint256 voteCount;
        bool isElected;
    }

    mapping(address => Voter) public voters;
    mapping(uint256 => Candidate) public candidates;
    mapping(address => bool) public admins;

    Counters.Counter private candidateCounter;

    uint256 public totalVotes;
    uint256 public totalSeats;
    uint256 public quota;

    event VoterRegistered(address voter);
    event VoteCast(address voter, uint256[] choices);
    event CandidateAdded(string name);
    event ElectionResult(string[] winners);
    event CandidateEliminated(string candidateName, uint256 round);
    event VotesRedistributed(string candidateName, uint256 round);
    event CandidateElected(string candidateName, uint256 round);

    modifier onlyAdmin() {
        require(admins[msg.sender], "Only admins can perform this action.");
        _;
    }

    constructor(uint256 _totalSeats) {
        totalSeats = _totalSeats;
        admins[msg.sender] = true;
    }

    function addCandidate(string memory _name) public onlyAdmin {
        candidateCounter.increment();
        uint256 candidateId = candidateCounter.current();
        candidates[candidateId] = Candidate({
            name: _name,
            voteCount: 0,
            isElected: false
        });
        emit CandidateAdded(_name);
    }

    function registerVoter() public {
        require(!voters[msg.sender].isRegistered, "Already registered.");
        voters[msg.sender].isRegistered = true;
        emit VoterRegistered(msg.sender);
    }

    function castVote(uint256[] memory _choices) public nonReentrant {
        require(voters[msg.sender].isRegistered, "Voter not registered.");
        require(!voters[msg.sender].hasVoted, "Voter has already voted.");
        require(_choices.length == candidateCounter.current(), "Invalid choices.");

        voters[msg.sender].choices = _choices;
        voters[msg.sender].hasVoted = true;
        totalVotes++;

        uint256 firstChoice = _choices[0];
        candidates[firstChoice].voteCount++;

        emit VoteCast(msg.sender, _choices);
    }

    function calculateQuota() public view returns (uint256) {
        return (totalVotes / (totalSeats + 1)) + 1;
    }

    function tallyVotes() public onlyAdmin {
        require(totalVotes > 0, "No votes registered.");
        quota = calculateQuota();

        string[] memory winners = new string[](totalSeats);
        uint256 winnersCount = 0;
        uint256 round = 1;

        while (winnersCount < totalSeats) {
            bool candidateElected = false;
            for (uint256 i = 1; i <= candidateCounter.current(); i++) {
                if (candidates[i].voteCount >= quota && !candidates[i].isElected) {
                    candidates[i].isElected = true;
                    winners[winnersCount] = candidates[i].name;
                    winnersCount++;
                    candidateElected = true;

                    emit CandidateElected(candidates[i].name, round);

                    redistributeExcessVotes(i);
                }
            }

            if (!candidateElected) {
                eliminateCandidate(round);
            }

            round++;
        }

        emit ElectionResult(winners);
    }

    function redistributeExcessVotes(uint256 candidateId) internal {
        uint256 excessVotes = candidates[candidateId].voteCount - quota;

        for (uint256 i = 0; i < totalVotes; i++) {
            address voterAddress = msg.sender; 
            if (voters[voterAddress].choices[0] == candidateId) {
                for (uint256 j = 1; j < voters[voterAddress].choices.length; j++) {
                    uint256 nextChoice = voters[voterAddress].choices[j];
                    if (nextChoice != candidateId && !candidates[nextChoice].isElected) {
                        candidates[nextChoice].voteCount += excessVotes / (totalVotes - quota);
                        emit VotesRedistributed(candidates[candidateId].name, j);
                        break;
                    }
                }
            }
        }
    }

    function eliminateCandidate(uint256 round) internal {
        uint256 lowestVoteCount = type(uint256).max;
        uint256 candidateToEliminate;

        for (uint256 i = 1; i <= candidateCounter.current(); i++) {
            if (candidates[i].voteCount < lowestVoteCount && !candidates[i].isElected) {
                lowestVoteCount = candidates[i].voteCount;
                candidateToEliminate = i;
            }
        }

        emit CandidateEliminated(candidates[candidateToEliminate].name, round);

        for (uint256 i = 0; i < totalVotes; i++) {
            address voterAddress = msg.sender;
            if (voters[voterAddress].choices[0] == candidateToEliminate) {
                for (uint256 j = 1; j < voters[voterAddress].choices.length; j++) {
                    uint256 nextChoice = voters[voterAddress].choices[j];
                    if (nextChoice != candidateToEliminate && !candidates[nextChoice].isElected) {
                        candidates[nextChoice].voteCount++;
                        emit VotesRedistributed(candidates[candidateToEliminate].name, round);
                        break;
                    }
                }
            }
        }
    }

    function signVote(bytes32 hash, bytes memory signature) public pure returns (address) {
        return ECDSA.recover(hash, signature);
    }

    function verifySignature(bytes32 hash, bytes memory signature, address signer) public pure returns (bool) {
        return ECDSA.recover(hash, signature) == signer;
    }
}