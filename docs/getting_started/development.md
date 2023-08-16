---
title: Development
layout: post
menu_position: 2
---

# Rauversion Server Installation Guide

This guide will walk you through the steps to install and start your Rauversion server.

## Prerequisites

Before you begin, ensure you have the following installed on your machine:

- Ruby
- Rails
- Yarn
- Lame
- FFMPEG
- audiowaveform
- vips

## Step 1: Install Dependencies

First, you need to install the necessary dependencies. You can do this by running the following command in your terminal:

```bash
bundle install
```

## Step 2: Configure Environment Variables

Next, you need to rename the `.env.example` file to `.env` and add your variable configurations. This file contains environment-specific settings that are loaded every time your application starts.

## Step 3: Set Up Database

After setting up your environment variables, you need to create and migrate your database. You can do this by running the following command in your terminal:

```bash
rails db:setup
```

## Step 4: Compile Assets

Next, you need to compile your assets using Yarn. You can do this by running the following command in your terminal:

```bash
yarn install
```

## Step 5: Start the Server

Finally, you can start your Rails server by running the following command in your terminal:

```bash
./bin/dev
```

Now, you can visit [`localhost:3000`](http://localhost:3000) from your browser to see your Rauversion server in action.

## Credits

### Flag rendering API:

- [Flagpedia API](https://flagpedia.net/download/api)

### Image credits:

- Photo by [Daniel Schludi](https://unsplash.com/@schluditsch?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)

If you encounter any issues during the installation process, please refer to the [troubleshooting guide](#) or contact our [support team](#).