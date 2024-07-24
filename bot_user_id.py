from slack_sdk import WebClient
from slack_sdk.errors import SlackApiError

import os

from dotenv import load_dotenv

load_dotenv()

slack_token = os.getenv("SLACK_BOT_TOKEN")
print(slack_token)

client = WebClient(token=slack_token)

response = client.auth_test()
print(response)