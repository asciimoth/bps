use teloxide::prelude::*;
use teloxide::types::{MessageKind, MediaKind};
use dotenv::dotenv;

#[tokio::main]
async fn main() {
    dotenv().ok();
    pretty_env_logger::init();
    let bot = Bot::from_env().auto_send();
    teloxide::repl(bot, |msg: Message, bot: AutoSend<Bot>| async move {
        let chat_id = msg.chat.id;
        if let MessageKind::Common(message) = msg.kind {
            if let Some(user) = message.from {
                if let MediaKind::Sticker(sticker) = message.media_kind {
                    let sticker = sticker.sticker;
                    if sticker.is_animated {
                        log::info!("Premium sticker by {:?} {}", user.username, user.id.0);
                        bot.ban_chat_member(chat_id, user.id).await?;
                    }else{
                        log::info!("Normal sticker by {:?} {}", user.username, user.id.0);
                    }
                }
            }
        }
        respond(())
    })
    .await;
}
