"""
Module for e-mail notification
"""
import os
import sys
import logging
import pathlib
from dotenv import load_dotenv
import telegram


logger = logging.getLogger(__name__)


def notify_telegram(msg: str):
    _env_path = pathlib.Path(__file__).parent.joinpath(".env_telegram")
    if not os.path.exists(_env_path):
        logger.info(".env_telegram file not found. Can't send the following notification: %s",
                    msg)
        return
    try:
        load_dotenv(pathlib.Path(__file__).parent.joinpath(".env_telegram"))
        bot = telegram.Bot(os.environ["TELEGRAM_BOT_TOKEN"])
        bot.send_message(text=msg, chat_id=os.environ["TELEGRAM_RECIPIENT"])
    except Exception as err:
        logger.error("Could not send notification: %s", str(err))


if __name__ == '__main__':
    # Test it out
    notify_telegram("Hello World")
