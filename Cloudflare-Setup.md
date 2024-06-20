# Cloudflare Setup

This document describes the steps to configure a new cloudflare account ready for zero trust access

### Setting up Cloudflare Account for Access

##### **Login to your Cloudflare account:** Navigate to Zero Trust

![AccountSetup](./images/cf-setup/Setup-1.png)

##### **First Time Setup:** For the first time setup create a team name which will be used later on for access from the client.

> [!IMPORTANT]
> If this is the first time you are creating the cloudflare account it will ask you for the billing information which can be set to the Free plan for non-production use.

> [!NOTE]
> This name can be updated later on if required

![AccountSetup](./images/cf-setup/Setup-2.png)

##### **Setup Tunnel Configuration** ([Cloudflare Docs](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/get-started/create-remote-tunnel/)) Create a Tunnel with the connector Cloudflared.

![AccountSetup](./images/cf-setup/Setup-3.png)
![AccountSetup](./images/cf-setup/Setup-4.png)

##### **Specify the Tunnel name (it needs to be unique)**

![AccountSetup](./images/cf-setup/Setup-5.png)

##### **Skip the connector setup/installation page**

![AccountSetup](./images/cf-setup/Setup-6.png)

##### **Create the Private Network which should be the CIDR range of the VPC or the subnet in AWS that should be allowed access via the tunnel**

> ![alt text](image.png) [More details here](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/private-net/cloudflared/)

![AccountSetup](./images/cf-setup/Setup-7.png)

### API Key Setup

##### **Access the My Profile from the top menu**

![API Setup](./images/cf-setup/API-1.png)

##### **Access API Tokens and Select Create Token**

![API Setup](./images/cf-setup/API-2.png)

##### **Create new token by selecting Get Started under Custom Token**

![API Setup](./images/cf-setup/API-3.png)

##### **Add the token name, permissions and TTL (if required)**

> Permissions required are Cloudflare Tunnel - Edit and Account Settings - Read

![API Setup](./images/cf-setup/API-4.png)

##### **Test the token using the curl command from any device**

![API Setup](./images/cf-setup/API-5.png)

### WARP Device Enrollment ([Cloudflare Docs](https://developers.cloudflare.com/cloudflare-one/connections/connect-devices/warp/deployment/device-enrollment/))

##### **Create a device enrollment profile** The device enrollment profile defines various measures to control which devices can access the tunnel. For the purpose of this setup, we can create a profile that will be filtered based on the country.

![Enrollment](./images/cf-setup/WARP-1.png)

##### **Edit the default profile**

![Enrollment](./images/cf-setup/WARP-2.png)

##### **Include all IP and Domains in the settings** This allows access to all the IPs within the AWS VPC/Subnet

![Enrollment](./images/cf-setup/WARP-3.png)

##### **Add Device Enrollment Rules**

![Enrollment](./images/cf-setup/WARP-5.png)

##### **Add Rules**

![Enrollment](./images/cf-setup/WARP-6.png)

##### **Specify the rules that will be used for allowing device enrollment**

![Enrollment](./images/cf-setup/WARP-7.png)

##### **Validate the Tunnel status** This validation will show "Healthy" once the deployment of the terraform resources has been completed

![Enrollment](./images/cf-setup/WARP-4.png)

### Client Setup

![ClientSetup](./images/cf-setup/Client-1.png)

![ClientSetup](./images/cf-setup/Client-2.png)

![ClientSetup](./images/cf-setup/Client-3.png)

![ClientSetup](./images/cf-setup/Client-4.png)

![ClientSetup](./images/cf-setup/Client-5.png)

![ClientSetup](./images/cf-setup/Client-6.png)
