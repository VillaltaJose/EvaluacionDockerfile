FROM ubuntu:latest

RUN apt-get update
RUN apt-get install -y curl gnupg

RUN curl -sL https://deb.nodesource.com/setup_22.x | bash -
RUN apt-get -y install nodejs

RUN apt-get install -y nginx

RUN npm install -g @angular/cli

COPY nginx.conf /etc/nginx/sites-available/default
RUN rm -rf /var/www/html/*

VOLUME /app/front
WORKDIR /app/front

CMD ["bash", "-c", "npm install --force && ng build && cp -r /app/front/dist/front/* /var/www/html && nginx -g 'daemon off;'"]
EXPOSE 80