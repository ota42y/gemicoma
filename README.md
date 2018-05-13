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

## Setup
Create Github OAuth App  
https://github.com/settings/developers 

```bash
export GITHUB_CLIENT_ID=xxx
export GITHUB_CLIENT_SECRET=yyy
export GITHUB_ACCESS_TOKEN=zzz

./bin/rails s
```

# import rubygems dump

## install postgres container and clone rubygems docker

```bash
# other session
cd scripts/rubygems_docker
docker-compose up

cd scripts/rubygems_docker
docker-compose run rubygems /scripts/import_ruygem_data

cd ../../
./bin/rails runner scripts/import_script.rb

```
