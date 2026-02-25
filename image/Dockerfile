FROM ubuntu:22.04

# Install system dependencies
RUN apt-get update && apt-get install -y \
    wget curl libicu-dev libssl-dev ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 1. Install the specific baseline version (24.9.2.1834)
RUN wget https://github.com/Manager-io/Manager/releases/download/24.9.2.1834/ManagerServer-linux-x64.tar.gz \
    && tar -xzf ManagerServer-linux-x64.tar.gz \
    && rm ManagerServer-linux-x64.tar.gz

# 2. Pull your management script from your GitHub RAW link
RUN wget -O /usr/local/bin/manage_manager https://raw.githubusercontent.com/nw2hd/manager-io/refs/heads/main/manager-docker-tools/manage_manager.sh \
    && chmod +x /usr/local/bin/manage_manager

EXPOSE 8080

# Run the ManagerServer
CMD ["./ManagerServer", "-port", "8080", "-path", "/data"]
