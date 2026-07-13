# Appwrite Contract Testing with Specmatic

This directory contains configuration, scripts, and examples for testing the Appwrite implementation against the official OpenAPI specifications using Specmatic.

## Benefits of Specmatic
Contract testing ensures that the Appwrite API strictly adheres to the OpenAPI specification (`specs` repo). Unlike standard E2E tests, Specmatic:
- Automatically explores the API space based on the contract schema.
- Runs Schema Resiliency tests to verify robustness against unexpected payloads or boundary values.
- Validates examples before they are used, ensuring documentation stays accurate.

## Setup & Running Locally
1. Start Appwrite and Specmatic services using Docker Compose:
   ```bash
   docker compose -f docker-compose.yml -f docker-compose.specmatic.yml up specmatic --abort-on-container-exit
   ```
2. Specmatic will automatically wait for the Appwrite API to become healthy, run the tests, and report results.

## Validating Examples
To strictly validate the external examples in `tests/contract/examples` against the OpenAPI spec:
```bash
docker compose -f docker-compose.yml -f docker-compose.specmatic.yml run specmatic-validate
```

## API Coverage
Our goal is to achieve 100% API coverage for critical modules, starting with the `Account` API.

## Issues Discovered
*(To be populated as discrepancies are found between the OpenAPI spec and Appwrite implementation)*

