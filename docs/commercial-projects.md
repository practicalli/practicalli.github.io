# Commercial Projects

Experiences from Clojure related commercial projects.


## Data ingestion and distribution

Leading a globally distributed set of developments, team building the next generation in data services to support the Equities business at Citi.

Responsible for services consumed by dozens of other technical stakeholders, liaising with many other development teams to understand their requirements and challenges. Working closely with those teams to enhance solutions provided by the teams I was responsible for. 

Involved in software development, testing, DevOps and even operations resouce management (acquiring physical servers & hard drives for Oracle database servers)

I defined standards and practices for the team within Citi tooling and regulation constraints, shaping the use of development tools and services and driving architecture discussions that shaped technical decisions within the team. 

The main technology stack is based on Clojure along with a myriad of enterprise technology services and products to create a global system processing millions of transactions per day. I also advocate functional programming and the Clojure programming language throughout the organisation.

Leading the move to Cloud Infrastructure for our systems and start to evolve the core product architecture into an immutable event stream with Kafka.

Citi is a leading financial services company with a truly global reach – 200 million customer accounts in more than 160 countries.


## Natural Language Processing


## Sports Data 

Working with various stakeholders to create Clojure microservices and Kafka based data processing pipeline that generates a GraphQL API of sports statistics from live match events.

Working closely with StatsBomb customer success and founders to meet the needs of our customers and provide technical assistance using the data API.

Designed and constructed an Authorization and entitlement management system for the GraphQL API to secure our comprehensive sports statistics for customers and 3rd party applications. Wrote detailed user guides for customers to use the GraphQL API, configure 3rd party applications and generate tokens to access the service.

### Data enrichment pipeline

Events in a sports match are scraped manually from video to create a baseline of play.

Events data is enriched based on the surrounding events.

A complete picture of all the actions in the game are generated for analytics.

Individual match data is aggregated to provide player and team statistics throughout the sports year.

All data is stored in a Postgresql database and Hasura used to generate a GraphQL API.

![Sports Data enrichment pipeline](https://github.com/practicalli/graphic-design/blob/live/commercial-projects/sports-data-enrichment-pipeline.png?raw=true){loading=lazy}

### GraphQL Authentication

Hasura has access rules to define which data can be accessed, however, there was no direct support for OAuth token validation.

Hasura did provide a webhook so that each request could query an API to validate every request.

A Clojure API was created using reitit and JWT middleware, checking customer tokens via OAuth.

Hasura was used to generate rules to control access

The Clojure API returned an x-hasura header if the access token was valid.  The hasura token contained data to be used by the hasura rules to control access to the graphql result.

The Clojure API checked the token from every request made to the GraphQL API.

Integrant was used to manage the software components in the Clojure web service.

![Sports Data graphql authentication webhook](https://github.com/practicalli/graphic-design/blob/live/commercial-projects/sports-data-graphql-query-authentication-hasura.png?raw=true){loading=lazy}


## Fraud Detection

Clojure Engineering in financial services, working with amazing people to deliver Fraud Detection using Machine Learning models

Building a data pipeline with a range of service orchestration (internal and external) to supply comprehensive, accurate and timely data for processing via scientific models. Enabling the data science models to be effectively trained and instantly detect fraudulent activity within Fintech transactions

Supported improvements in DevOps and Engineering workflows and practices, defining a range of common practices across the organisation.

Unfortunately the role ended abruptly due to sudden economic shock.

TODO: Structurizr diagrams
