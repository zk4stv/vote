const { google } = require('googleapis');
const Web3 = require('web3');
const fs = require('fs');
const path = require('path');

// Configurações do Google Sheets
const sheets = google.sheets('v4');
const SPREADSHEET_ID = 'YOUR_SPREADSHEET_ID';
const SHEET_RANGE = 'Sheet1!A1';

// Configurações do Web3 e do contrato
const web3 = new Web3(new Web3.providers.HttpProvider('https://mainnet.infura.io/v3/YOUR_INFURA_PROJECT_ID'));
const contractAddress = '0xSeuContratoAddressAqui';
const contractABI = JSON.parse(fs.readFileSync(path.resolve(__dirname, 'contractABI.json'), 'utf8'));
const contract = new web3.eth.Contract(contractABI, contractAddress);

// Função para registrar voto no Google Sheets
async function registrarVotoNoGoogle(voto) {
  const auth = await google.auth.getClient({
    scopes: ['https://www.googleapis.com/auth/spreadsheets']
  });
  const request = {
    spreadsheetId: SPREADSHEET_ID,
    range: SHEET_RANGE,
    valueInputOption: 'USER_ENTERED',
    resource: {
      values: [[voto.timestamp, voto.primeiraEscolha, voto.segundaEscolha, voto.terceiraEscolha]]
    },
    auth: auth
  };
  try {
    const response = await sheets.spreadsheets.values.append(request);
    console.log('Voto registrado no Google Sheets:', response.data);
  } catch (err) {
    console.error('Erro ao registrar voto no Google Sheets:', err);
  }
}

// Função para registrar voto na Blockchain
async function registrarVotoNaBlockchain(voto) {
  const accounts = await web3.eth.getAccounts();
  const account = accounts[0];
  try {
    const receipt = await contract.methods.registrarVoto(voto.primeiraEscolha, voto.segundaEscolha, voto.terceiraEscolha)
      .send({ from: account });
    console.log('Voto registrado na Blockchain:', receipt);
  } catch (err) {
    console.error('Erro ao registrar voto na Blockchain:', err);
  }
}

// Exemplo de uso das funções
const voto = {
  timestamp: new Date().toISOString(),
  primeiraEscolha: 'Opção 1',
  segundaEscolha: 'Opção 2',
  terceiraEscolha: 'Opção 3'
};

registrarVotoNoGoogle(voto);
registrarVotoNaBlockchain(voto);