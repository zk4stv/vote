const { google } = require('googleapis');
const Web3 = require('web3');
const fs = require('fs');
const path = require('path');

// Configurações do Google Sheets
const sheets = google.sheets('v4');
const SPREADSHEET_ID = process.env.SPREADSHEET_ID;
const SHEET_RANGE = 'Sheet1!A1';

// Configurações do Web3 e do contrato
const web3 = new Web3(new Web3.providers.HttpProvider(`https://mainnet.infura.io/v3/${process.env.INFURA_PROJECT_ID}`));
const contractAddress = process.env.CONTRACT_ADDRESS;
const contractABI = JSON.parse(fs.readFileSync(path.resolve(__dirname, 'contractABI.json'), 'utf8'));
const contract = new web3.eth.Contract(contractABI, contractAddress);

// Função para registrar voto no Google Sheets
async function registrarVotoNoGoogle(voto) {
  try {
    const auth = await google.auth.getClient({
      scopes: ['https://www.googleapis.com/auth/spreadsheets']
    });
    const request = {
      spreadsheetId: SPREADSHEET_ID,
      range: SHEET_RANGE,
      valueInputOption: 'USER_ENTERED',
      resource: {
        values: [[voto.timestamp, ...voto.choices]]
      },
      auth: auth
    };
    const response = await sheets.spreadsheets.values.append(request);
    console.log('Voto registrado no Google Sheets:', response.data);
  } catch (err) {
    console.error('Erro ao registrar voto no Google Sheets:', err);
    throw err; // Lançar o erro para tratamento externo
  }
}

// Função para registrar voto na Blockchain (não é mais necessária, pois é feita em vote-options.js)
// async function registrarVotoNaBlockchain(voto) { ... }

// Exemplo de uso das funções (adaptado)
async function registrarVoto(choices) {
  const voto = {
    timestamp: new Date().toISOString(),
    choices: choices
  };

  try {
    const txHash = await processarVoto(voto.timestamp, voto.choices); // Chamar a função de vote-options.js
    await registrarVotoNoGoogle(voto);
    console.log('Voto registrado com sucesso na blockchain e no Google Sheets. Hash da transação:', txHash);
  } catch (error) {
    console.error('Erro ao registrar o voto:', error);
  }
}

module.exports = { registrarVoto };