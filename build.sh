RAILS_IMAGE=docker.pkg.github.com/alxckn/teacher_den/rails:latest
NGINX_IMAGE=docker.pkg.github.com/alxckn/teacher_den/nginx:latest

docker build -t teacher_den/rails ./rails -f ./rails/Dockerfile.alpine
docker tag teacher_den/rails $RAILS_IMAGE
docker push $RAILS_IMAGE

# docker build -t teacher_den/upload_doc ./rails -f ./rails/Dockerfile.alpine --target upload_doc

docker build -t teacher_den/nginx ./nginx
docker tag teacher_den/nginx $NGINX_IMAGE
docker push $NGINX_IMAGE
