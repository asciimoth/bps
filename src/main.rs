use teloxide::prelude::*;
use teloxide::types::{MessageKind, MediaKind};
use dotenv::dotenv;
use std::env;

fn get_bool_var(name: &str) -> bool {
    if let Ok(param) = env::var(name) {
        return param == String::from("true");
    }
    false
}

#[tokio::main]
async fn main() {
    dotenv().ok();
    let for_all = get_bool_var("FOR_ALL_STICKERS");
    let kick = get_bool_var("KICK_USERS");
    pretty_env_logger::init();
    let bot = Bot::from_env().auto_send();
    log::info!("Starting bot");
    teloxide::repl(bot, move |msg: Message, bot: AutoSend<Bot>| async move {
        let chat_id = msg.chat.id;
        let msg_id = msg.id;
        if let MessageKind::Common(message) = msg.kind {
            if let Some(user) = message.from {
                if let MediaKind::Sticker(sticker) = message.media_kind {
                    let sticker = sticker.sticker;
                    if sticker.is_animated {
                        log::debug!("Premium sticker by {:?} {}", user.username, user.id.0);
                        if kick { bot.kick_chat_member(chat_id, user.id).await?; }
                        bot.delete_message(chat_id, msg_id).await?;
                    }else{
                        log::debug!("Normal sticker by {:?} {}", user.username, user.id.0);
                        if for_all {
                            if kick { bot.kick_chat_member(chat_id, user.id).await?; }
                            bot.delete_message(chat_id, msg_id).await?;
                        }
                    }
                }
            }
        }
        respond(())
    })
    .await;
    log::info!("Stopping bot");
}
