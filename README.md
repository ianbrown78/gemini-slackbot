# Gemini powered Slackbot

A simple, effective Gemini Pro powered Slack bot.

## Installation

### Initial Checks

Open src/main.py and update the model you want to use on line 24.

### Infrastructure
We will be deploying this to Google Cloud.

You will need to have a project created already to use this code and it will need to have a billing account.

Open the terraform/run.tf file and ensure everything is commented out.  
Open terraform/variables.tf and update the project_id variable with your project.

Ensure you have ADC logged in using:  
`gcloud auth application-default login`

Run `terraform init`, then `terraform plan`, and if there are no errors, `terraform apply -auto-approve`

These commands do the following:  
- Enables specific APIs as defined in the variables.tf
- Creates a Google Artifact Registry Docker registry named 'slack-images'
- Creates two Secrets Manager secrets for the Slack OAuth token and Google AI token
- Pulls down a reference to the default compute service account.

### Container Image

In this step we use the `docker` command to build container images.  
If you use podman or another docker replacement, adapt the commands appropriately.

Firstly we need to ensure we are authenticated to Artifact Registry using the below command:  
`gcloud auth configure-docker australia-southeast1-docker.pkg.dev`

Now we build the image:  
`docker build -t australia-southeast1-docker.pkg.dev/<your_project_id>/slackbot-images/slackbot:latest -f Dockerfile .`

Once that completes, we push the image to the repo with the below command:  
`docker push australia-southeast1-docker.pkg.dev/<your_project_id>/slackbot-images/slackbot:latest`

Please ensure you update the `<your_project_id>` with your actual project id.

### Slack Part One

Head over to https://api.slack.com/apps

Click the "Create an App" button.  
Select "From scratch" from the options.  
Give the app a name and if you have miltuple workspaces, select the one you want to use for the bot.
Click "Create App"

On the left, select "OAuth & Permissions" and add the below OAuth Scopes:  
- app_mentions:read
- channels:history
- chat:write
- im:history
- im:write
- mpim:history

Add a dummy redirect URL of https://localhost/  
Click "Install to Workspace" to generate the token.  
Copy the "Bot User OAuth Token" and save it to the "slack_token" secret in GCP.

### Gemini AI

Head over to https://ai.google.dev/ and click the big blue button that says "Get API key in Google AI Studio"

Enter your project ID and select "Create API in existing project"

This will reveal an API Key. Copy this and save it to the "google_api_key" secret in GCP.

### Cloud Run

Open the terraform/run.tf and uncomment everything and save the file.

Run `terraform apply` to plan and apply the Cloud Run instance.

Once it is deployed, copy the URL from the deployment and navigate back to Slack.

### Slack Part Two

On the left, navigate to "Event Subscriptions".

In the "Request URL" box, paste the URL from the Cloud Run deployment and append `/slack/events` to the URL.  
Click out of the box to initiate the challenge.  
If this step is successful, move on, otherwise you will need to troubleshoot what happened.

Expand the "Subscribe to bot events" and add the below bot event subscriptions:  
- app_mention
- message:im
- message:mpim

Once this is complete, click "Save Changes" at the bottom of the page.

Lastly, navigate to "App Home" on the left.
- Enable "Always Show My Bot as Online"
- Check "Allow users to send Slash commands and messages from the messages tab"

## Congratulations

You now have a working slackbot configured that uses Gemini AI 1.5 Pro.
Jump into slack and test it out by mentioning the name of your bot in a channel.
