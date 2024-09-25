// Importar a biblioteca ethers.js
const { ethers } = require('ethers');

// Configurar o provedor Ethereum (por exemplo, usando Infura)
const provider = new ethers.providers.InfuraProvider('homestead', process.env.INFURA_PROJECT_ID);

// Configurar a carteira (substitua pela sua chave privada)
const wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider);

// ABI do contrato Solidity (substitua pelo ABI do seu contrato)
const contractABI = require('./contractABI.json');

// Endereço do contrato (substitua pelo endereço do seu contrato)
const contractAddress = process.env.CONTRACT_ADDRESS;

// Instanciar o contrato
const contract = new ethers.Contract(contractAddress, contractABI, wallet);

// Função para processar o voto
async function processarVoto(timestamp, choices) {
  const voto = {
    timestamp: timestamp,
    choices: choices
  };

  try {
    // Chamar a função do contrato para registrar o voto
    const tx = await contract.castVote(voto.timestamp, voto.choices);
    await tx.wait();
    console.log('Voto registrado com sucesso:', tx);
    return tx.hash; // Retornar o hash da transação
  } catch (error) {
    console.error('Erro ao registrar o voto:', error);
    throw error; // Lançar o erro para tratamento externo
  }
}

module.exports = { processarVoto };