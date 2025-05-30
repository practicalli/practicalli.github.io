---
title: Clojure REPL driven API project from scratch
date:
  created: 2024-07-21
  updated: 2024-07-21
authors:
  - practicalli
categories:
  - clojure
tags:
  - clojure
  - api
draft: true
---

Creating a comprehensive API project in Clojure.

??? HINT "Practicalli Project Templates"
    [Practicalli Project Templates](https://practical.li/clojure/clojure-cli/projects/templates/practicalli) provides several templates to build production level projects. Generated projects can include component management systems, e.g. donut-party/system or integrant.

    Create a new project called gameboard managed by donut-party/system with an example API service and swagger documentation.
    ```shell
    clojure -T:project/create :template practicalli/service :name practicalli/gameboard :component donut
    ```

<!-- more -->

## Create a project

Create a Clojure CLI project using Practicalli Clojure CLI config.  Clojure 1.12. supports hot loading of library dependencies.

```shell
clojure -T:project/create :template practicalli/application :name practicalli/repl-driven-api
```

## Start REPL

Start a REPL process along with nREPL server to enable your Clojure aware editor to connect to the REPL and give instant feedback.

!!! EXAMPLE "Start a REPL with nREPL server & a rich terminal UI"
```shell
clojure -M:repl/rebel
```

> The REPL could also be started from a Clojure aware editor (jack-in)


## Web server

The Web Server listens to HTTP requests and sends HTTP responses back to the calling client.


Http kit and jetty are the most commonly used web servers.  Http-kit is predominantly written in Clojure and will be used for these examples


!!! EXAMPLE "Add http-kit library"
    ```shell
    ;; add-libs command
    ```


!!! EXAMPLE "Add function to start & stop http-kit server"
    ```clojure

    ```

## Convert HTTP request to Clojure

Ring is the defacto library that bridges the world of HTTP requests & responses with Clojure. Ring acts as an adaptor on top of the web server.

Ring converts an HTTP request into a Clojure Hash Map, the request map.

Once a response has been created, Ring converts the response map into an HTTP response.

!!! EXAMPLE "Add Reitit libraries"
    ```shell

    ```

## Routing http requests

Routing takes a request and sends it to a header function to create a response.

Reitit configuration is a hash-map with HTTP type (GET, POST, )
Add a request router function to dispatch requests to specific handler functions

!!! EXAMPLE "Add a reitit-ring router"
    ```clojure

    ```

> Reitit is a library that provides routing for both Clojure and ClojureScript.  Reitit-ring provides the webserver adaptor for back-end Clojure applications.  Reitit also includes libraries for middleware, coersion, etc.




[Anatomy of a Clojure Web Service](https://practical.li/clojure-web-services/app-servers){target=_blank .md-button}

??? INFO:


## Service REPL



## Integrant


Integrant is a data centric approach although I would like simpler code design to work with.


Integrant REPL is a separate library


## Donut



A data as code approach, extended by simple functions

defmethod only used to create different system types, so only a minimal used (unless there is a very complex set of systems)

REPL tools are built into the System library.



## Reloadable Code

Minimise
- macros
- defmethod, deftype, defrecord


## Exclude code from reload

Set refresh directories to include all paths except those that should be excluded from the reload, e.g `(set-refresh-dirs "src" "resources")` will exclude the `"test"` and `"dev"` directories from the refresh.

The `set-refresh-dirs` function returns the directory paths set, so including the function call within a printlin expression provides useful feedback on REPL startup.

!!! EXAMPLE "Set directories to reload"
    ```clojure
    (require '[clojure.tools.namespace.repl :refer [set-refresh-dirs]])

    ;; ---------------------------------------------------------
    ;; Avoid reloading `dev` code
    ;; - code in `dev` directory should be evaluated if changed to reload into repl
    (println
     "Set REPL refresh directories to "
     (set-refresh-dirs "src" "resources"))
    ;; ---------------------------------------------------------
    ```


---
Thank you.

[:globe_with_meridians: Practical.li Website](https://practical.li){target=_blank .md-button}

[:fontawesome-brands-github: Practical.li GitHub Org](https://github.com/practicalli){target=_blank .md-button}
[:fontawesome-brands-github: practicalli-johnny profile](https://github.com/practicalli-johnny){target=_blank .md-button}

[:fontawesome-brands-mastodon: @practicalli@clj.social](https://clj.social/@practicalli){target=_blank .md-button}
[:fontawesome-brands-twitter: @practical_li](https://twitter.com/practcial_li){target=_blank .md-button}
