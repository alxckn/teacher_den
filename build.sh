RAILS_IMAGE=docker.pkg.github.com/alxckn/teacher_den/rails:latest
NGINX_IMAGE=docker.pkg.github.com/alxckn/teacher_den/nginx:latest

docker build -t teacher_den ./rails
docker tag teacher_den $RAILS_IMAGE
docker push $RAILS_IMAGE

docker build -t teacher_den_nginx ./nginx
docker tag teacher_den_nginx $NGINX_IMAGE
docker push $NGINX_IMAGE
