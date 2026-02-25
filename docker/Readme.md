# Manager.io Docker Server - Universial docker-compose and env

This is a customized Docker image for Manager.io Server, pre-configured for stability and ease of use.

## Quick Start
1. Download the `docker-compose.yml` and `.env` files.
2. Place them in a folder on your server.
3. Run the following command:
```
#bash
docker-compose up -d
   ``` 
4.Access your server at http://your-ip:8080


# Configuration

You can edit the .env file to change the following:

    APP_PORT: Change 8080 if you want to use a different port.

    IMAGE_TAG: Change this to roll back to a specific version.

    TIMEZONE: Set your local timezone (e.g., Asia/Kuala_Lumpur or America/New_York).
