#!/bin/bash
set -e

# Wait for Appwrite to be ready
echo "Waiting for Appwrite to be healthy..."
until curl -fsS -o /dev/null "http://localhost/v1/health/version"; do
  echo "Still waiting..."
  sleep 5
done
echo "Appwrite is ready."

# In a real scenario, this would create a project/user and export keys.
# For testing the Account API, we might just need to ensure the console is initialized
# or create a test user.

echo "Setup complete."

