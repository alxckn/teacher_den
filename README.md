# Docker

Run `./build.sh` to build and push necessary images (access rights necessary).

## Run in prod

Make sure your `.env` is filled correctly:
```
SECRET_KEY_BASE="lalalla"
DATABASE_URL=postgres://<username>:<password>@<docker_host>/teacher_den_production
SENDGRID_USERNAME=apikey
SENDGRID_PASSWORD="lalallalala"
```

Deploy procedure:
```
docker-compose pull # to update images locally
docker-compose down # downtime here unfortunately
docker-compose up # restart services (nginx + rails)
```

## Run locally

First off, create a `.env` file at the root of this repo to setup some variables:

```
SECRET_KEY_BASE=lallalallalalala
```

Make sure to install [docker](https://docs.docker.com/engine/install/debian/) and [docker-compose](https://docs.docker.com/compose/install/).

To use docker-compose in a local environment, prefix all docker-compose commands with: `docker-compose -f docker-compose.yml -f docker-compose.local.yml`:
  - To start the stack, run `docker-compose -f docker-compose.yml -f docker-compose.local.yml up` and then head to your browser (`http://localhost:8080`)
  - On the first run in development, you will need to init the postgres database:
    - `docker-compose -f docker-compose.yml -f docker-compose.local.yml bundle exec rails db:create`
    - `docker-compose -f docker-compose.yml -f docker-compose.local.yml bundle exec rails db:migrate`

# Upload documents

A ruby script (`rails/bin/upload_doc`) makes it easy to upload documents from the command line.

You can use it with the rails docker image:
  - If the site is running locally, make sure to get the local computer ip using `ip addr show` (usually shows under docker0 network adapter for docker ce installs)
  - Currently, the docker image to use is `docker.pkg.github.com/alxckn/teacher_den/rails`
  - `docker run -v $(pwd):/data <image_name> bundle exec bin/upload_doc -a <host> -c <category> -u <email> -p <password> -f /data/<document_name.pdf>`

# Backups

TODO: right now backups are handled with obsolete backup gem, we need another system, probably external to rails
