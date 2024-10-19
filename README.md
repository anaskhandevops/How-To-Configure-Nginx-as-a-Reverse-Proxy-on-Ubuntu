# How To Configure Nginx as a Reverse Proxy on Ubuntu
In this tutorial, we will set up NGINX as a reverse proxy, whether your website is running on the host machine or in a Docker container. This guide will walk you through configuring the reverse proxy for your website.
## Step to do
- Deploy a website with docker
- For Local Setup - set hostname & add entry into /etc/hosts
- Configure nginx as a reverse proxy
  
## Deploy a website with docker
This step is `optional` if you already have a website running either on the host machine or in a Docker container and only need to configure NGINX as a reverse proxy. You can skip this step. However, if you are new or running a test, please follow below steps.
### Step 1: clone the repo
```
git clone https://github.com/anaskhandevops/How-To-Configure-Nginx-as-a-Reverse-Proxy-on-Ubuntu.git
```
### Step 2: Build the Docker Image
Navigate to the directory where your `myapp` folder is located. Open a terminal and run the following command:
```cd How-To-Configure-Nginx-as-a-Reverse-Proxy-on-Ubuntu
docker build -t myapp .
```
This command tells Docker to build an image named myapp using the Dockerfile in the current directory (.).
### Step 3: Run the Docker Container
After the image is built, you can run it using the following command:
```
docker run -d -p 8080:80 myapp
```
This command runs the container in detached mode (-d), and it maps port 80 inside the container to port 8080 on your Ubuntu server (-p 8080:80).
### Step 4: Access Your App
Once the container is running, you can access your app by navigating to `http://localhost:8080` in your web browser.

## For Local Setup - set hostname & add entry into /etc/hosts
This step for only for local setup, for example if you are testing on vmware workstation, otherwise you can skip that part.
### Step 1: Set hostname
```
hostnamectl set-hostname myapp.net
exec bash  # this command will update the hostname without restarting the machine
```
### Step 2: Add entry in /etc/hosts
```
nano /etc/hosts
127.0.0.1 myapp.net myapp
```
### Step 3: Access Your App
Verify that if you can now access the app with domain.
```
http://myapp.net:8080
```

## Configure nginx as a reverse proxy
now we have a site running in docker, lets setup nginx as a reverse proxy.
### Step 1: Install Nginx
first we need to install nginx, run the the belwo command:
```
sudo apt update; sudo apt install nginx -y
sudo systemctl status nginx
```
### Step 2: configuration file for myapp
Make sure to change replace the `site domain [myapp.net]` and the `port`
```
sudo cat << 'EOF' >> /etc/nginx/sites-available/myapp
server {
    listen 80;
    server_name myapp.net www.myapp.net;

    location / {
        proxy_pass http://localhost:8080;  
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

    }
}
EOF
```
### Step 3: Enable configuration file and reload the nginx
```
ln -s /etc/nginx/sites-available/myapp /etc/nginx/sites-enabled/myapp
rm /etc/nginx/sites-enabled/default
systemctl reload nginx
```
### Step 4: Access the app
```
http://myapp.net
```



