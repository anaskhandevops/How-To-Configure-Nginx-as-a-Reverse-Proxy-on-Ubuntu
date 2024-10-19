# Use an official NGINX image as the base
FROM nginx:alpine

# Copy the content of your app (index.html, style.css) to the default directory served by NGINX
COPY ./myapp /usr/share/nginx/html

# Expose the default NGINX port
EXPOSE 80
