# Gemicoma
[![CircleCI](https://circleci.com/gh/ota42y/gemicoma.svg?style=svg)](https://circleci.com/gh/ota42y/gemicoma)

# Setup

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version
2.5.3

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

# Development Setup

## env file
`cp .env.example .env`  
and write tokens (see below)  

### create Github OAuth App
Create Github OAuth App in this page.  
https://github.com/settings/developers 

And set `GITHUB_CLIENT_ID` `GITHUB_CLIENT_SECRET`

### GITHUB_ACCESS_TOKEN
create github `GITHUB_ACCESS_TOKEN`  
this token can read repository. 

## build docker
```
docker network create gemicoma_link
docker-compose build
docker-compose up
```

## Setup Database
Connect to database and create user.  
(We use localhost:15432 by default, docker-compose provide database by this port. )

```
psql -h localhost -p 15432 -U postgres
create role gemicoma with createdb login password 'gemicoma';

docker-compose run app sh -c "cd /var/www/app && ./bin/rake db:create db:migrate"
```

## Setup Admin
First, access to application and login by github account. 
http://localhost:13000/

And create admin user by rails console

```
docker-compose run app rails c

# create admin user 
User.first.create_admin
```

## add repository
http://localhost:13000/admin/github/repositories/new

