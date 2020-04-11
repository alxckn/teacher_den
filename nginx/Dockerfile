FROM docker.pkg.github.com/alxckn/teacher_den/rails:latest

FROM nginx:latest

COPY ./default.conf /etc/nginx/conf.d/default.conf
# COPY ./nginx.conf /etc/nginx/nginx.conf

RUN mkdir /var/www/
WORKDIR /var/www/

COPY --from=0 /app/public public/

EXPOSE 8080
