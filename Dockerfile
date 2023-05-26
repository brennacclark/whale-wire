# Set the working directory
FROM --platform=linux/amd64 debian:buster

# Ensure you modify the following variables to fit your environment
# NOTE: You can also pass these variables in when running the docker container
######################################################################################
# Path Name to SSH Key
ARG SSH_KEY_PATH="cert/id_rsa"
# STT Name for Chipper Setup [coqui (1), leopard (2), vosk (3)]
ARG STT="vosk"
# Production Bot
ARG PRODUCTION_BOT=true
###############################################################################

# Install Python and pip
RUN apt-get update && apt-get install -y python3 python3-pip libc6-dev wget

# Install Go 1.18
RUN apt-get update && apt-get install -y curl && \
    curl -LO https://golang.org/dl/go1.18.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.18.linux-amd64.tar.gz && \
    rm go1.18.linux-amd64.tar.gz

# Set Python environment variables
ENV PYTHONPATH="/usr/bin/python3"

# Set Go environment variables
ENV PATH="/usr/local/go/bin:${PATH}"
ENV GOPATH="/go"
ENV GOBIN="/go/bin"

# Clone the wire-pod repository
RUN apt-get install -y git && \
    git clone https://github.com/kercre123/wire-pod.git /app/wire-pod

# Installing avahi-daemon (and dbus)
# dbus is required for docker container compatibility
RUN apt-get update && apt-get install -y \
    dbus \
    avahi-daemon \
    && rm -rf /var/lib/apt/lists/* \
    && dbus-uuidgen > /var/lib/dbus/machine-id

# Mount local volume
VOLUME /Users/Brenna/Repositories/_volume:/app/wirebox-volume

VOLUME /var/run/dbus:/var/run/dbus

# Copy the GitHub SSH private key
# NOTE: Ensure you replace 'cert/id_rsa', 
COPY ${SSH_KEY_PATH} /root/.ssh/id_rsa
RUN chmod 600 /root/.ssh/id_rsa

# Configure SSH to use the key
RUN echo "Host github.com\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config

# Set working directory
WORKDIR /app/wire-pod

# Expose port 8080
EXPOSE 8080

# Install missing dependencies
RUN go install github.com/grpc-ecosystem/grpc-gateway/protoc-gen-grpc-gateway@latest

# Run the application 
# 1. Run Wire-Prod Chipper Setup
# 2. Start Chipper
# 3. Start the dbus start && service avahi-daemon (if PRODUCTION_BOT=true)
ENTRYPOINT sh -c 'STT=vosk ./setup.sh && ./chipper/start.sh && service dbus start && service avahi-daemon start'