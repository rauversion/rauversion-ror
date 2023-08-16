---
title: Digital Ocean deployment
layout: post
menu_position: 3
---

# Deployment Guide to DigitalOcean

This guide will walk you through the steps to deploy your application to DigitalOcean using GitHub Actions.

## Prerequisites

Before you begin, ensure you have the following:

- A DigitalOcean account
- A GitHub account
- A Rauversion fork so you can run a github action to build the image.

## Step 1: Set Up DigitalOcean Access Token

First, you need to generate a Personal Access Token (PAT) from DigitalOcean. This token will be used by GitHub Actions to interact with your DigitalOcean account.

1. Log in to your DigitalOcean account.
2. Navigate to the API section in the account settings.
3. Click on the `Generate New Token` button.
4. Give your token a name and ensure both `Read` and `Write` permissions are checked.
5. Click on the `Generate Token` button to create the token.
6. Copy the token and save it somewhere safe. You won't be able to see it again.

## Step 2: Set Up GitHub Secrets

Next, you need to add your DigitalOcean Access Token and Registry Name as secrets in your GitHub repository. These secrets will be used by the GitHub Actions workflow.

1. Navigate to your GitHub repository.
2. Click on the `Settings` tab.
3. Click on the `Secrets` section on the left sidebar.
4. Click on the `New repository secret` button.
5. Add `DIGITALOCEAN_ACCESS_TOKEN` as the name and paste your DigitalOcean Access Token as the value.
6. Click on the `Add secret` button to save it.
7. Repeat the process for `REGISTRY_NAME`.

## Step 3: Set Up GitHub Actions Workflow

Your fork will already activate the github action for you. The docker action is called dockerimage.yml

Once you've done this, GitHub Actions will automatically build and push your Docker image to your DigitalOcean Container Registry whenever you push to your repository.

## Step 4: Deploy to DigitalOcean

Finally, you can deploy your application to DigitalOcean.

1. Log in to your DigitalOcean account.
2. Navigate to the `Apps` section.
3. Click on the `Launch Your App` button.
4. Select the `Container Registry` option.
5. Choose the Docker image you want to deploy.
6. Click on the `Launch Basic App` button to deploy your application.


## Step 5: Add the resources.

### Web server

1. Add a server instance with the following start command: `bundle exec rails s -b 0.0.0.0 -p 3000`
2. set the HTTP port at 3000

### Jobs

1. Add a worker service
2. ad a start command with: bundle exec sidekiq

Check the environment variables article to setup your app variables

If you encounter any issues during the deployment process, please refer to the [troubleshooting guide](#) or contact our [support team](#).