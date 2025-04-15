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

## Running locally

You can run the server with

```
bundle exec rails s
```

By default, it will run on localhost port 3000.

You can test the GraphQL API by making the following request with cURL:

```
curl -XPOST localhost:3000/graphql\
  -H "Content-Type: application/json"\
  -d '{"query": "{testField}" }'
```