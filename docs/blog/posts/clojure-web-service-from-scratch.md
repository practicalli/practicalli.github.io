---
title: "Clojure Web Service from scratch"
date:
  created: 2020-12-31
  updated: 2025-05-30
authors:
  - practicalli
categories:
  - clojure
tags:
  - clojure
  - api
draft: true
---

An API web service in Clojure can be easily created from Scratch using the REPL and a few Clojure tools.

Only requirements are a Java VM, Clojure CLI and your favourite editor (with Clojure support ideally).

> NOTE: for a working server, clone xxx or generate a project using the [Practicalli Project Templates]()


## Create a simple Clojure project

> NOTE: new projects should start simply to avoid creating unnecessary abstractions of levels of indirection

Create a project configuration file containing an empty map and the `src` and `test` directories.

```shell
echo '{}' > deps.edn && \
mkdir src test
```


> The install of Clojure CLI includes the latest stable version of Clojure and includes the `src` directory on the JVM classpath, so any Clojure files under `src` can be loaded into the REPL.

Start a REPL, ideally with an nREPL server so we can connect an editor to it.

```shell
clojure -M:repl/rebel
```

Test the REPL is workng by typing a Clojure expression, my favourite test is

```clojure
(map inc [1 2 3 ])
```

This should return a sequence of `(2 3 4)`.



## Web Server

Add an embedded web server to run the API, using the Ring specification for processing HTTP requests and responses as Clojure hash-maps.

Reitit libraries will be used to run the web server, manage routing, middleware, requests and responses.

Use the Clojure CLI to find the current version of a library (in a separate terminal window to the REPL)

```shell
clojure -X:deps find-versions :lib metosin/reitit
```

The latest version is `0.9.1`

```shell-output
❯ clojure -X:deps find-versions :lib metosin/reitit

Downloading: metosin/reitit/maven-metadata.xml from clojars
{:mvn/version "0.7.0-alpha8"}
{:mvn/version "0.7.0"}
{:mvn/version "0.7.1"}
{:mvn/version "0.7.2"}
{:mvn/version "0.8.0-alpha1"}
{:mvn/version "0.8.0"}
{:mvn/version "0.9.0"}
{:mvn/version "0.9.1"}
❯
```


Add the library to the REPL using the add-libs library

```clojure
;; add-libs function call
```


I am happy the library is working, so I'll add the library to the `deps.edn` project configuration



## Request routing

TODO: add reitit-ring router


Define routes

Define default route

Add Swagger docs

Test API with swagger UI

Test API via REPL.
