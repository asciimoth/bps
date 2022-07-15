# Ban Premium Stickers
This bot allows you to prevent the usage of those cursed premium stickers in your telegram chat  
![Cursed](https://i.imgur.com/CRCg3rD.png)
## Configuration
Bot is controlling by the following environment variables  
### TELOXIDE_TOKEN
Telegram bot token received from [@BotFather](https://t.me/BotFather)
### RUST_LOG
Logging level  
It can take the following values
+ error
+ warn
+ info
+ debug
+ trace
### FOR_ALL_STICKERS
By default, bot reacts to premium stickers only,  
but you can also make it react to any stickers using `FOR_ALL_STICKERS=true`
### KICK_USERS
By default, bot only deletes messages with stickers,  
but you can also configure it to kick users who send them using `KICK_USERS=true`
## Instalation
### From source
```
git clone https://github.com/DomesticMoth/bps.git
cd bps
make build
make install
```
