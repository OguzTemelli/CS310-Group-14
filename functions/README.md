# DormMate Firebase Functions

This directory contains Firebase Cloud Functions for the DormMate application, primarily handling email notifications using Brevo (SendInBlue).

## Functions Overview

1. `sendPurchaseConfirmationEmail`: Automatically sends confirmation emails when users purchase memberships
   - Triggers on: New documents in `user_purchases` collection
   - Sends: Purchase confirmation to the user

2. `sendFeedbackEmail`: Handles feedback submission emails
   - Triggers on: New documents in `user_feedback` collection
   - Sends: Confirmation to the user and notification to admin

3. `testSendEmail`: HTTP endpoint for testing email functionality
   - Accessible via: Firebase Functions URL
   - Usage: Development/testing only

## Environment Setup

The functions use environment variables to securely store API keys. To set up:

1. Create a `.env` file in the functions directory with:
   ```
   BREVO_API_KEY=your_brevo_api_key_here
   ```

2. For production deployment, set Firebase environment configuration:
   ```
   firebase functions:config:set brevo.api_key="your_brevo_api_key_here"
   ```

> **Important**: Never commit your `.env` file or API keys to version control.

## Local Development

```bash
# Install dependencies
npm install

# Run Firebase emulator
firebase emulators:start --only functions

# Deploy functions
firebase deploy --only functions
``` 