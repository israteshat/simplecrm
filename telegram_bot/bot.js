const TelegramBot = require('node-telegram-bot-api');
const axios = require('axios');
const token = process.env.TELEGRAM_TOKEN || '';
if(!token){ console.error('Set TELEGRAM_TOKEN'); process.exit(1); }
const bot = new TelegramBot(token, {polling:true});

bot.onText(/\/start/, (msg)=>{
  bot.sendMessage(msg.chat.id, 'Hello! This is SimpleCRM companion bot. Send /voice to record a message.');
});

// voice file handling basic example - expects a voice message and responds with text placeholder
bot.on('voice', async (msg)=>{
  const fileId = msg.voice.file_id;
  try{
    const file = await bot.getFileLink(fileId);
    // download and send to your ASR service (placeholder)
    console.log('voice file', file);
    bot.sendMessage(msg.chat.id, 'Thanks! Received voice message — processing (placeholder).');
  }catch(err){ console.error(err); bot.sendMessage(msg.chat.id, 'Error processing voice'); }
});

console.log('Telegram bot running');
