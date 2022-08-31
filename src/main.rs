// Bps
// Copyright (C) 2022  DomesticMoth
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
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
                    if sticker.is_animated || sticker.is_video {
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
