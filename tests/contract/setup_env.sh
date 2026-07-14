#!/bin/bash
set -e

# Wait for Appwrite to be ready
echo "Waiting for Appwrite to be healthy..."
until curl -fsS -H "X-Appwrite-Key: ${APPWRITE_MASTER_KEY}" -o /dev/null "http://localhost/v1/health"; do
  echo "Still waiting..."
  sleep 5
done
echo "Appwrite is ready."

# Ensure master key is set
if [ -z "${APPWRITE_MASTER_KEY}" ]; then
  echo "Error: APPWRITE_MASTER_KEY is not set"
  exit 1
fi

# Create a temporary test project via Appwrite API
# Requires an admin API key set in the environment as APPWRITE_MASTER_KEY
PROJECT_RESPONSE=$(curl -s -X POST "http://localhost/v1/projects" \
  -H "Content-Type: application/json" \
  -H "X-Appwrite-Project: _all" \
  -H "X-Appwrite-Key: ${APPWRITE_MASTER_KEY}" \
  -d '{"name":"specmatic-test-project","description":"Project for Specmatic CI tests"}')
# Extract the project ID correctly
PROJECT_ID=$(echo "$PROJECT_RESPONSE" | jq -r '.["$id"]')
if [ -z "$PROJECT_ID" ]; then
  echo "Error: Failed to extract project ID"
  exit 1
fi

# Create an API key for the test project
APIKEY_RESPONSE=$(curl -s -X POST "http://localhost/v1/projects/${PROJECT_ID}/keys" \
  -H "Content-Type: application/json" \
  -H "X-Appwrite-Project: _all" \
  -H "X-Appwrite-Key: ${APPWRITE_MASTER_KEY}" \
  -d '{"name":"specmatic-ci-key","scopes":["account.read","account.update","account.delete","users.read","users.update"]}')
APPWRITE_API_KEY=$(echo $APIKEY_RESPONSE | jq -r '.key')

# Export variables for downstream Docker Compose steps
export APPWRITE_PROJECT_ID=$PROJECT_ID
export APPWRITE_API_KEY=$APPWRITE_API_KEY
# Write to GitHub Actions environment for downstream steps
if [ -n "$GITHUB_ENV" ]; then
  echo "APPWRITE_PROJECT_ID=$PROJECT_ID" >> $GITHUB_ENV
  echo "APPWRITE_API_KEY=$APPWRITE_API_KEY" >> $GITHUB_ENV
fi


# In a real scenario, this would create a project/user and export keys.
# For testing the Account API, we might just need to ensure the console is initialized
# or create a test user.

echo "Setup complete."

