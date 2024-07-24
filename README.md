# Gemini powered Slackbot

A simple, effective Gemini Pro powered Slack bot.

## Installation

We will be deploying this to Google Cloud Run.
Therefore, you will need to have the gcloud SDK installed and authenticated.

### Configuration
Add the following variables to Cloud Run:

GOOGLE_API_KEY='your_google_api_key'
SLACK_BOT_TOKEN='your_slack_token'
BOT_USER_ID='your_bot_user_id'
FLASK_APP="app.py"

Ensure you update the key, token and id as appropriate.

### Deployment

Once you have completed the coding section, deploy the application using the gcloud cli:  
`gcloud run deploy`

Create your slack bot app:  

