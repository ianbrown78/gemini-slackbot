from flask import Flask, request, jsonify
from slack_sdk import WebClient
from slack_sdk.errors import SlackApiError

import threading
import pathlib
import textwrap
import os

from dotenv import load_dotenv

import google.generativeai as gai
from threading import Thread

processed_ids = set()

# Load environment variables from .env file.
# This will become obsolete in the demo version.
load_dotenv()

# Define Google API Key and set Gemini Pro model
google_api_key = os.getenv('GOOGLE_API_KEY')
gai.configure(api_key=google_api_key)
model = gai.GenerativeModel('gemini-1.5-flash-latest')

# Initialise a Web Client with the Slack token
slack_token = os.getenv('SLACK_TOKEN')
client = WebClient(token=slack_token)

# Get BOT_USER_ID from the auth_test
auth_test = client.auth_test()
BOT_USER_ID = auth_test["user_id"]

app = Flask(__name__)

def handle_event_async(data):
	thread = Thread(target=handle_event, args=(data,),daemon=True)
	thread.start()

def handle_event(data):
	event = data["event"]

	# Check if the event is a message without a subtype
	if "text" in event and event["type"] == "message" and event.get("subtype") is None:
		print(f'Received Event Text: {event["text"]}')

        # Ignore messages from the bot itself
		if event.get("user") == BOT_USER_ID:
			return

        # Handle direct message or app mention
		if event["channel"].startswith('D') or event.get("channel_type") == 'im':
            # Handle direct message event
			try:
				gemini = model.generate_content(event["text"])
				textout = gemini.text.replace("**", "*")
				print(textout)

				response = client.chat_postMessage(
                    channel=event["channel"],
                    text=textout,
                    mrkdwn=True
                )
			except SlackApiError as e:
				print(f"Error posting message: {e.response['error']}")

	elif event["type"] == "app_mention" and event.get("client_msg_id") not in processed_ids:
		try:
			gemini = model.generate_content(event["text"])
			textout = gemini.text.replace("**", "*")
			print(textout)

			response = client.chat_postMessage(
				channel=event["channel"],
				text=textout,
				mrkdwn=True
			)
			processed_ids.add(event.get("client_msg_id"))
		except SlackApiError as e:
			print(f"Error posting message: {e.response['error']}")


@app.route('/gemini', methods=['GET'])
def hellowworld():
	if request.method == 'GET':
		gemini = model.generate_content("Hi")
		return gemini.text

@app.route("/slack/events", methods=["POST"])
def slack_events():
	data = request.json
	if "challenge" in data:
		return jsonify({"challenge": data["challenge"]})

	if "event" in data:
		handle_event_async(data)

	return "", 200

if __name__ == "__main__":
	app.run(debug=True)
