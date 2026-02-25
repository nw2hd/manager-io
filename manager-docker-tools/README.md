# Manager.io Server - Optimized Docker Image

This repository provides a specialized Docker image for **Manager.io Server**. It is designed for stability and flexibility, allowing users to choose their preferred version while providing a reliable "baseline" where core features work perfectly.

## Why use this Dynamic Image?

Unlike standard Docker images that force you to use one specific version or always the "latest" (which can be buggy), this image provides:

1.  **Stable Baseline:** We start with version **24.9.2.1834**. 
    > **Note:** This is the last known version where the **PDF Button function** works perfectly on the server side. In many versions released after this, the PDF generation has known issues.
2.  **User Choice:** You can stay on the stable baseline or upgrade to any newer release at your own risk.
3.  **In-Container Management:** No need to rebuild the image or pull new layers from Docker Hub to change versions. Everything is handled via an internal script.

---

## Installation

### 1. Requirements
* Docker and Docker Compose installed on your host (Linux, aaPanel, Portainer, or NAS).

### 2. Setup
Create a folder for your project and add the following `docker-compose.yml`:

```yaml
services:
  manager-server:
    image: nw2hd/manager-io:dynamic
    container_name: manager-server
    ports:
      - "8080:8080"
    volumes:
      - ./data:/data
    restart: unless-stopped
    environment:
      - TZ=UTC # Change to your timezone
```


3. Start the Server
Run the following command in your terminal:

```Bash


docker-compose up -d
```

Access the interface at http://your-ip:8080.

## How to use manage_manager
We have included a powerful management tool inside the image. This allows you to upgrade or downgrade the Manager.io binaries without touching your Docker configuration.
To Change Versions:
Open your server terminal (or aaPanel terminal).
Run the management tool:
```Bash
docker exec -it manager-server manage_manager
```

  > **Step 1**: Confirm you have backed up your data.
 
  > **Step 2**: Select a version from the list of the 10 most recent GitHub releases.
 
  > **Step 3**: The script will download the version, apply it, and restart the container automatically.

## Important Warnings
  > **PDF Functionality**: If you upgrade beyond version 24.9.2.1834, you may lose the ability to generate PDFs directly via the "PDF" button. Always test new versions before committing to them for your business.
  
  > **Backups**: Always perform a manual backup of your /data folder before using the manage_manager tool to switch versions.

## Contributing & Support
If you find this image helpful, feel free to star the repo! For issues regarding the Manager.io software itself, please visit the [Manager.io Forum](https://forum.manager.io).
Maintained by nw2hd
