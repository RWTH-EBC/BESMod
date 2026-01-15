# How to set up telegram

Create a file .env-telegram in this folder.
The content:

```
TELEGRAM_BOT_TOKEN="$TOKEN"  # As string
TELEGRAM_RECIPIENT=$recepient_id  # As integer
```

Send a message to your bot. Then, get your `$recepient_id` by doing the following:

```python
import telegram
TOKEN = "$TOKEN"  # Insert token as string
bot = telegram.Bot(TOKEN)
RECIPIENT_ID = bot.get_updates()[0]["message"].chat.id
print(RECIPIENT_ID)
```

The output is your id. Check if it really works by calling:

```python
import telegram
TOKEN = "$TOKEN"  # Insert token as string
RECIPIENT_ID = 0  # Insert id as integer
bot = telegram.Bot(TOKEN)
bot.send_message(text="Hello World", chat_id=RECIPIENT_ID)
```
