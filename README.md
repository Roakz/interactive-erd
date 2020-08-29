### Interactive ERD

![CI run tests](https://github.com/Roakz/interactive-erd/workflows/CI%20run%20tests/badge.svg?event=push)

This repo will contain a small web APP. It will be some ruby logic Im write to extract the entities from an sql file and return a JSON object. This will be wrapped with some lightweight Sinatra endpoints to create a small api. 

There will then be a an SPA written with REACT (Typescript). This will form the user interface for supplying the sql file. The return json will be formatted into templates an become an interactive ERD. This will work with large scale applications and show the relational data model in a neat, tidy and interactive way.