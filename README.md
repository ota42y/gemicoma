# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

## Development Setup
Create Github OAuth App
https://github.com/settings/developers 

```bash
cp .env.example .env
docker-compose up
```

## create database user
connect to database

psql -h localhost -p 15432 -U postgres
create role gemicoma with createdb login password 'gemicoma';

## build docker
docker-compose build
docker-compose up
docker-compose run app sh -c "cd /var/www/app && ./bin/rake db:create db:migrate"

---login user---

docker exec -it gemicoma_app_1 bash
rails c

# create admin user 
User.first.create_admin


# import rubygems dump

## install postgres container and clone rubygems docker

```bash
# other session
cd scripts/rubygems_docker
docker-compose up

cd scripts/rubygems_docker
docker-compose run rubygems /scripts/import_ruygem_data master

cd ../../
./bin/rails runner scripts/import_script.rb

```

