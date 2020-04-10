RAILS_IMAGE=docker.pkg.github.com/alxckn/teacher_den/rails:latest

docker build -t teacher_den ./rails
docker tag teacher_den $RAILS_IMAGE
# docker push $RAILS_IMAGE
