# Whale-Wire 

## A Dockerized Wire-Pod Environment

Our beloved, [Wire-Pod](https://github.com/kercre123/wire-pod), now bundled onto a Debian Docker Image. 

Designed for deployment on OS X (Apple Chip M1). 

- [Prerequistes](#prerequisites)
- [Verify your Installation Settings](#verify-your-installation-settings)
- [Build the whale-wire image and deploy](#build-the-whale-wire-image-and-deploy)
- [Connect to Wire-Pod](#connect-to-wire-pod)
- [Reset Vector to Factory Settings](#reset-vector-to-factory-settings)
- [Authenticate Vector on whale-wire-pod](#authenticate-vector-on-whale-wire-pod)

# Prerequisites

### 1. Create a Docker account and Install Docker
Verify that you have Docker installed by running the following command:
``` sh
docker --version
```

### 2. Generate an SSH key pair if you haven't already done so. 
You can use the ssh-keygen command to generate a new SSH key pair. </br>
For example:
``` sh
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

### 3. Copy the contents of the public key (id_rsa.pub file) by running the following command:
``` sh
cat ~/.ssh/id_rsa.pub
```

### 4. Add SSH Key to Github
* Go to your GitHub account settings and navigate to "SSH and GPG keys". Click on "New SSH key" or "Add SSH key". 
* Give your SSH key a suitable title, such as "Wire-Box SSH Key".
* Paste the contents of the public key into the "Key" field and save the SSH key.

### 5. Place your private key file in the same directory as the Dockerfile
* The default used in the dockerfile `certs/id_rsa`

<hr>

# Verify your Installation Settings

* Verify your private id_rsa can be accessed. </br>
    _Update ENTRY_POINT ssh key path for non-default values_
* Verify you are using your preferred STT. </br>
    _Update ENTRY_POINT with new STT name_
* If you are not using a production bot, remove the last command from ENTRY POINT </br>
    _Update ENTRY_POINT and remove `service dbus start && service avahi-daemon start`_

# Build the whale-wire image and deploy

### 1. Build the Docker image, run the following command:
``` sh
docker build --platform=linux/arm64 -t whale-wire:myTag .
```

### 2. After building the image, you can run a container and map port 6400 to the host using the -p flag:

``` sh
docker run -h myhostname --name mycontainername myimage:tag
# or 
docker run -it -h escapepod --name escapepod -p 8080:8080 whale-wire:myTag
```

## Whale-wire will then run the application
### 1. (Production Bots Only) Start the dbus start && service avahi-daemon
### 2. Run Wire-Pod Chipper Setup
### 3. Start Chipper

### It should show a log similar to the following.
``` sh
Initializing variables
SDK info path: /home/kerigan/.anki_vector/
API config JSON created
Initiating vosk voice processor with language 
Loading plugins
Wire-pod is not setup. Use the webserver at port 8080 to set up wire-pod.
Starting webserver at port 8080 (http://localhost:8080)
Starting SDK app
Starting server at port 80 for connCheck
Configuration page: http://192.168.1.221:8080
```

# Connect to wire-pod

### With a device on the same network as wire-pod, open a browser and head to the configuration page you just deployed http://localhost:8080. In that page, follow the instructions. Wire-pod should then be set up!

![Wire-Pod Interface Header](https://github.com/brennacclark/whale-wire/blob/main/assets/wireProdConfigHeader.png)

### Above logs will continue
``` sh
...
Downloading https://alphacephei.com/vosk/models/vosk-model-small-en-us-0.15.zip to /tmp/vosk-model-small-en-us-0.15.zip
Configuration changed, writing to disk
Opening VOSK model (../vosk/models/en-US/model)
VOSK initiated successfully
Loaded 54 intents and 54 matches (language: en-US)
Reloaded voice processor successfully
Configuration changed, writing to disk
Configuration changed, writing to disk
Configuration changed, writing to disk
Initiating TLS listener, cmux, gRPC handler, and REST handler
Starting chipper server at port 443
Starting chipper server at port 8084 for 2.0.1 compatibility
wire-pod started successfully!
```

Note: You may need to restart the avahi-daemon after configuration

``` sh
service dbus start && service avahi-daemon restart
```

# Reset Vector to Factory Settings

1. Place Vector on the charger
1. Double press his button
1. Lift his lift up then down
1. Take Vector off of the charger and twist one of the wheels until the cursor is on "RESET" (or "CLEAR USER DATA")
1. Lift the lift up then down again
1. Move the wheel until the cursor is on "CONFIRM"
1. Lift the lift up then down again


# Authenticate Vector on whale-wire-pod 

PRODUCTION BOTS ONLY, skip if you have an OSKR/dev-unlocked bot as the setup.sh script will handle it: It is recommended to clear your bot's user data. This is not required, and you can still authenticate with wire-pod without it (as long as the last server you have authenticated the bot with was the DDL/Anki production stack), but it may cause unexpected behavior.

- Refresh the [vector-wirepod-setup page](https://keriganc.com/vector-wirepod-setup/html/main.html) and follow the instructions

- You should end up at a screen with an "ACTIVATE" button. Click on it.

![Activate Button on Vector Setup](https://github.com/brennacclark/whale-wire/blob/main/assets/wireProdActivate.png)

- If it loads for a little bit then shows back up again, click on it again
Enter the desired settings (can be changed later) then click "SAVE SETTINGS".

### Your bot should now be fully authenticated and set up!

![Vector Wire-Pod Setup Complete](https://github.com/brennacclark/whale-wire/blob/main/assets/vectorSetupComplete.png)


</br>
</br>

</hr>

[Back to Top](#whale-wire)
