// Importar a biblioteca ethers.js
const { ethers } = require('ethers');

// Configurar o provedor Ethereum (por exemplo, usando Infura)
const provider = new ethers.providers.InfuraProvider('homestead', 'YOUR_INFURA_PROJECT_ID');

// Configurar a carteira (substitua pela sua chave privada)
const wallet = new ethers.Wallet('YOUR_PRIVATE_KEY', provider);

// ABI do contrato Solidity (substitua pelo ABI do seu contrato)
const contractABI = [
  // ABI do contrato
];

// Endereço do contrato (substitua pelo endereço do seu contrato)
const contractAddress = 'YOUR_CONTRACT_ADDRESS';

// Instanciar o contrato
const contract = new ethers.Contract(contractAddress, contractABI, wallet);

// Função para processar o voto
async function processarVoto(timestamp, primeiraEscolha, segundaEscolha, terceiraEscolha) {
  const voto = {
    timestamp: timestamp,
    choices: [primeiraEscolha, segundaEscolha, terceiraEscolha]
  };

  try {
    // Chamar a função do contrato para registrar o voto
    const tx = await contract.registrarVoto(voto.timestamp, voto.choices);
    await tx.wait();
    console.log('Voto registrado com sucesso:', tx);
  } catch (error) {
    console.error('Erro ao registrar o voto:', error);
  }
}

module.exports = { processarVoto };