### Interactive ERD

![CI run tests](https://github.com/Roakz/interactive-erd/workflows/CI%20run%20tests/badge.svg?event=push)

![Example of the ui](./public/vision.png)

This repo will contain a small web APP. It will be some ruby logic to extract the entities from an sql file and return a JSON object. This will be wrapped with some lightweight Sinatra endpoints to create a small api that serves an interactive pdf representation on en ERD.

The ERD will be interactive in the sense that it will be paginated and you will be able to click into the different entites to view them. You will be able to view the data types, keys and relationships of each entity and click through to there relations form within them.

The UI will be a basic bootsrap & ERB implementation.

