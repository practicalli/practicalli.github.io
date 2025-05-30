---
title: Clojure API Service from Practicalli minimal project template
date:
  created: 2020-12-31
  updated: 2025-05-24
authors:
  - practicalli
categories:
  - clojure
tags:
  - clojure-cli
  - api
draft: true
---

Build a Clojure API service from the ground up using Clojure CLI and Practicalli Project Templates.

Update: [Practicalli Clojure WebApps](https://practicalli.github.io/clojure-webapps/) has newer versions of this guide.  Take a look at the Status Monitor and Banking on Clojure projects

>
> This project will be used to build a web server that will serve our API, which we will build in future posts and [study group broadcasts](http://yt.vu/+practicalli).

<!-- more -->

# Create project

`:project/create` alias defined in [Practicalli Clojure CLI Config](https://practical.li/clojure/clojure-cli/practicalli-config/) uses the [deps-new]() tool to create projects and includes the [Practicalli Project Templates](https://practical.li/clojure/projects/) to create


> A minimal Clojure could be made by manually [creating a few files and directories](https://practical.li/clojure/clojure-cli/projects/#create-minimal-project).


In a terminal, create the project called `practicalli/simple-api-server`

```shell
clojure -T:project/create :template practicalli/minimal
```

??? EXAMPLE "Clojure Project Structure"
    The project structure from the `:practicalli/minimal`
    ```shell
    ❯ tree
    .
    ├── build.clj
    ├── CHANGELOG.md
    ├── deps.edn
    ├── dev
    │   ├── mulog_events.clj
    │   ├── portal.clj
    │   └── user.clj
    ├── LICENSE
    ├── Makefile
    ├── README.md
    ├── src
    │   └── practicalli
    │       └── playground.clj
    ├── test
    │   └── practicalli
    │       └── playground_test.clj
    └── tests.edn

    5 directories, 12 files
    ```

`deps.edn` contains the library dependencies for the project.  `:practicalli/minimal` contains the Clojure and [Mulog event log](https://github.com/BrunoBonacci/mulog) libraries.


`deps.edn` defines two aliases (possibly a few more).

* `:test` includes the `test.check` library and test code files under the `test` path.
* `:runner` sets the main namespace to that of the test runner, calling the `-main` function in that namespace which then runs all the tests under the directory `test`.

This creates a Clojure namespace (file) called `playground` in the `practicalli` domain.  The project contains the `clojure.core`, `test.check` and `test.runner` libraries by default.

??? EXAMPLE "Project configuration"

```clojure title="deps.edn"
{;; ---------------------------------------------------------
 :paths
 ["src" "resources"]
 ;; ---------------------------------------------------------

 ;; ---------------------------------------------------------
 :deps
 {;; Application
  org.clojure/clojure {:mvn/version "1.12.0"}
  com.brunobonacci/mulog {:mvn/version "0.9.0"}}
 ;; ---------------------------------------------------------

 ;; ---------------------------------------------------------
 :aliases
 {;; Clojure.main execution of application
  :run/app
  {:main-opts ["-m" "practicalli.playground"]}

  ;; Clojure.exec execution of specified function
  :run/greet
  {:exec-fn practicalli.playground/greet
   :exec-args {:name "Clojure"}}

  ;; Add libraries and paths to support additional test tools
  :test/env
  {}

  ;; Test runner - local and CI
  ;; call with :watch? true to start file watcher and re-run tests on saved changes
  :test/run
  {:extra-paths ["test"]
   :extra-deps {lambdaisland/kaocha {:mvn/version "1.91.1392"}}
   :main-opts   ["-m" "kaocha.runner"]
   :exec-fn kaocha.runner/exec-fn
   :exec-args {:randomize? false
               :fail-fast? true}}

  ;; tools.build `build.clj` built script
  :build/task
  {:replace-paths ["."]
   :replace-deps  {io.github.clojure/tools.build {:mvn/version "0.10.3"}}
   :ns-default    build}}}
 ;; ---------------------------------------------------------




 :aliases
 {:run-m {:main-opts ["-m" "practicalli.api-server"]}
  :run-x {:ns-default practicalli.simple-api-server
          :exec-fn greet
          :exec-args {:name "Clojure"}}
  :test {:extra-paths ["test"]
         :extra-deps {org.clojure/test.check {:mvn/version "1.1.0"}}}
  :runner
  {:extra-deps {com.cognitect/test-runner
                {:git/url "https://github.com/cognitect-labs/test-runner"
                 :sha "b6b3193fcc42659d7e46ecd1884a228993441182"}}
   :main-opts ["-m" "cognitect.test-runner"
               "-d" "test"]}
  :uberjar {:replace-deps {com.github.seancorfield/depstar
{:mvn/version "2.0.211"}}
            :exec-fn hf.depstar/uberjar
            :exec-args {:aot true
                        :jar "simple-api-server.jar"
                        :main-class "practicalli.simple-api-server"
                        :sync-pom true}}}}
```

The project created with [clj-new](https://github.com/seancorfield/clj-new#getting-started) contains all these files

![Clojure APIs - simple project](/images/clojure-simple-api-project-tree.png)


## Adding a web server

To create our Clojure web server we are going to use the httpkit project which is based on the common ring design for web servers.

Using httpkit it is easy to create a server and have functions to stop and start that server inside the REPL, all in a few lines of Clojure code.  Underneath is a powerful JVM server that has been tested to serve 600,000 concurrent HTTP request and supports many modes of operation (websockets, streaming, long polling).

Routing will be done using the compojure library, which is a common approach in the Clojure community (although there are other projects).


### Add httpkit dependency

Add the httpkit library to the project.

Edit the `project.edn` file and add `http-kit` version `2.5.3` to the `:deps` map of dependencies

```clojure
:deps
{org.clojure/clojure {:mvn/version "1.10.3"}
 http-kit/http-kit {:mvn/version "2.5.3"}}
```

### Add httpkit server namespace

Add the httpkit server namespace to the project namespace in which we are going to write the code that defines our server.

Edit `simple-api-server.clj` file and change the `ns` definition

```clojure
(ns practicalli.simple-api-server
  (:gen-class)
  (:require [org.httpkit.server :as server]))
```

> `:gen-class` allows us to run this namespace from the command line using the `java` command.


### define an httpkit server

Define a function that starts a Jetty server, taking a port number as an argument

When called, the function starts the server on the specified port and passes all requests to the handler function (which we define next).

The Jetty server listens on the port for all http requests.  Each request is converted by the httpkit server to a Clojure hash-map.

```clojure
(defn create-server
  "A ring-based server listening to all http requests
  port is an Integer greater than 128"
  [port]
  (server/run-server handler {:port port}))
```

> There are [several modes of operation](https://www.http-kit.org/server.html), simple HTTP server, async/websocket, HTTP streaming and long polling.  These modes can be configures as part of the `create-server` function.


### Add a handler

The `create-server` function creates a server that sends every request to the `handler` function.

The `handler` function take a request hash-map, bound to the `req` argument.

The `handler` should return a response hash-map, containing values for `:status`, `:body` and `:headers`.

```clojure
(defn handler
  "A function that handles all requests from the server.
  Arguments: `req` is a ring request hash-map
  Return: ring response hash-map including :status :headers and :body"
  [req]
  {:status  200
  :headers {}
  :body    "Hello Clojure Server world!"})
```

> **httpkit server request and response keys**
>
> The httpkit server creates a Clojure hash-map from each http request, referred to as the request hash-map, using the ring standard.
>
>The request hash-map contains [the ring request keys](https://github.com/ring-clojure/ring/wiki/Concepts#requests)
>
> The `handler` function returns a [ring response keys](https://github.com/ring-clojure/ring/wiki/Concepts#responses).


## Running the application

Start a REPL using the Clojure CLI tools, preferably using [rebel-readline](https://github.com/bhauman/rebel-readline#clojure-tools) for the complete REPL experience.

```shell
clojure -M:repl/rebel
```

In the REPL, load the namespace to include all the code in the running REPL.  Use the `:verbose` option to show what namespaces are loading if you are curious.

```clojure
(require '[practicalli.simple-api-server] :verbose)
```

Change to the namespace so you can call the functions directly from that namespace (otherwise you have to use `practicalli.simple-api-server/function-name` each time)

```clojure
(in-ns 'practicalli.simple-api-server)
```

Finally we can call the `create-server` function to start our webserver on a particular port.

```clojure
(create-server)
```

> **Spacemacs**
>
> 1) `SPC f f` to open a *.clj* file from the project
>
> 2) `,'` to start a REPL for this project (you could use the code above in the REPL buffer)
>
> 3) `, s n` to send current namespace to the repl
>
> 4) `, e b` evaluate all the code in the source file (loading the namespace code - can this be done instead of loading namespace)
>
> 5) `, s s` to switch to the REPL window
>
> 6) Enter `(create-server 8000)` and press `RET` to evaluate the function call and start the server.


## Testing our application

`clojure.test` library is built into Clojure that provides a simple unit test framework and test runner.  As its part of Clojure, all we need to do is require the library in the namespaces where we write our tests.  There are [several other test libraries and test runners](https://gist.github.com/plexus/a816a942c01b0e7af1e9836205100337) too.

For every namespace under `src` we wish to test, we create the same namespace under `test` directory and post-fix `-test` to the original name.  So in our project we have:

* `src/practicalli/simple-api-server` containing our application functions
* `test/practicalli/simple-api-server-test` containing our test functions

`deftest` function is used to define a test that can contain one or more assertions as well as use any setup and tear-down functions.

`is` function is used to define a single assertion, comparing a known value with the result of calling a function from the namespace under test.

### Requiring the namespace to be tested

The clj-new app template already created a `test/simple-api-server-test.clj` file and required `clojure.test` and the namespace to be tested.

Practicalli recommends changing the way the namespaces required.

* use a meaningful and consistent alias for the namespace to be tested, i.e `SUT`.

* refer specific functions from `clojure.test` that are used to define your tests, rather than the indiscriminate `:refer :all`

Edit `test/practicalli/simple-api-server-test.clj`  and update the `ns` definition to define the `SUT` alias for the namespace to be tested.

```clojure
(ns practicalli.simple-api-server-test
  (:require [clojure.test :refer [deftest is testing]]
            [practicalli.simple-api-server :as SUT]))
```

> **`SUT`** is a commonly used alias meaning [System Under Test](https://en.wikipedia.org/wiki/System_under_test).  The alias was added rather than including all functions using `:refer :all`.
>
> The alias makes it easy to see which functions are being called from the system under test and therefore provide an understanding of where they are being tested.


### Write a basic test

One of the simplest tests we can write it to check the handler is returning a request.  Specifically we can test if we are returning a `200` status that confirms the http request was successful.

> [HTTP status codes](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes) - Wikipedia

Edit `test/practicalli/simple-api-server-test.clj` and create a `handler-test` function, using the `deftest` macro from the `clojure.test` library.

The test function has one assertion, defined using the `is` function.

The assertion compares two values using the `=` function.

The first value is `200`, the HTTP status that means `OK`.

The second value is obtained by calling the `handler` function from `src/practicalli/simple-api-server` namespace.  The result of that call is a response map.  The `:status` keyword is used as a function call, taking the response map as an argument, returning the value associated with `:status` in the response map.

```clojure
(deftest handler-test
  (testing "Response to events"
    (is (= 200 (:status (SUT/handler {}))))))
```


## Running tests

In a terminal window, use the Clojure CLI tools to start the test runner and run all the results.

```shell
clj -A:test:runner
```

> **Spacemacs**
>
> `SPC u , s i` to edit the prompt for cider-jack-in
>
> add `-A:test` at the front of the command line, after `clj`, and press `RET`.  The REPL starts and includes the test path in the classpath and allows cider.test to be run from CIDER
>
> `, t a` will now run all tests when the cursor is in any of the Clojure files.
>
> Alternatively, define a .dir-locals.el file as set `:test` as the CLI global option for CIDER
> `((clojure-mode . ((cider-clojure-cli-global-options . "-A:test"))))`


## Adding a function to stop the server

We can start the server, but unless we have a reference to the server we cannot send it instructions to shut down.

A brutal way to stop the server is to simply quit the Clojure REPL, however, we can do better than that.

### Defining a reference for the server

Using the `def` function we can bind a name to the calling of the `create-server` function.  Then we can use that name to send a timeout instruction and gracefully shut down the server.

Define a name for the server and keep that name private, so only functions in the current namespace can use that name.

```clojure
(defonce ^:private api-server (create-server))
```

Now we can use the `api-server` name as a reference to the running server and send it commands.

```clojure
(api-server :timeout 100)

```

This is a simple approach, although we can use a Clojure `atom` instead.

### Define a binding for the server state

Define a Clojure atom that will hold a name that is bound to the server invocation when we start it.

When the `api-server` atom contains `nil` it means no server is running.

When the server is started we reset the `api-server` atom to contain a dynamic binding to the server.

The `api-server` atom can then be used to send a timeout to the running Jetty server process.

```clojure
(defonce ^:private api-server (atom nil))
```

### Stop server function

The Jetty server can be gracefully shut down by passing `:timeout` with a value in milliseconds.

The server will stop listening for new requests.

Existing requests will be processed and hopefully finish before the timeout expires.

Then the Jetty server process stops.

Then the atom containing the server binding is `reset!` to `nil`, updating the state of the server to stopped in the Clojure code.

```clojure
(defn stop-server
  "Gracefully shutdown the server, waiting 100ms "
  []
  (when-not (nil? @api-server)
    ;; graceful shutdown: wait 100ms for existing requests to be finished
    ;; :timeout is optional, when no timeout, stop immediately
    (@api-server :timeout 100)
    (reset! api-server nil)))
```


An updated `-main` function

```clojure
(defn -main [& args]
  ;; #' enables hot-reloading of the server
  (reset! api-server (server/run-server #'handler {:port (or (first args) 8080)})))
```


### Conditionally using a port number

The `-main` function uses the `& args` syntax for the argument.  This allows the `-main` function to be called with or without passing a value for the port.

We can use the `or` function to use a port number if it is passed as an argument.  If no port number is passed, then a default port number is used.

If `(first args)` is called when no argument is passed, then it is effectively same as `(first [])`.  When evaluaed this returns `nil`.


```clojure
(defn oring [& args]
  (or (first args)
      8000))

(oring)
;; => 8000

(oring 8888)
;; => 8888
```

### Conditional arguments for server configuration

Associative destructuring binds values from hash-maps to local symbols
We can use default values if values are not passed as arguments
& makes all arguments optional
the `:or` map provides local symbols and their default values

```clojure
(defn optional-keys [& {:keys [port timeout]
                        :or   {port 8000 timeout 100} }]
  (str "Port: " port ", timeout " timeout ))
```

call the function without arguments and the defaults are used

```clojure
(optional-keys)
;; => "Port: 8000, timeout 100"
```


;; call with one argument, :port and 8888 are a single key-value pair,
;; the argument is used and the missing argument uses the default value.

```clojure
(optional-keys :port 8888)
;; => "Port: 8888, timeout 100"
```

### Use associated destructuring for multiple arguments

Using an `or` statement within the function call to `run-server` arguments is okay when you have a single argument.  However it gets quite complex if you have multiple arguments

Associate destructuring can be used with the arguments passed to the server, in the argument list of the function definition.

Our function definition uses `&` in the argument list to take any number of arguments.

A single pair of `{}` is used to pattern match on key values pairs at the top level.

`:keys [,,,]` is used to to create local binding names from the matching keywords in the arguments passed.


```clojure
(defn -main
  "Start a httpkit server with a specific port
  #' enables hot-reload of the handler function and anything that code calls"
  [& {:keys [ip port]
      :or   {ip   "0.0.0.0"
             port 8000}}]
  (println "INFO: Starting httpkit server on port:" port)
  (reset! api-server (server/run-server #'handler {:port port})))
```

> The Httpkit server function includes an example of using [associative destructuring in the stop-server function](https://github.com/http-kit/http-kit/blob/master/src/org/httpkit/server.clj#L84) it returns and in the [server function argument list](https://github.com/http-kit/http-kit/blob/master/src/org/httpkit/server.clj#L34).

### Starting the server

Specify a specific port when starting the server

```clojure
(-main :port 8888)
;; => "Port: 8888, timeout 100"
```

Or simply start the server on the default port using `(-main)`


### Stopping the server

Stopping the server is easy, just call the `stop-server` functions witout arguments.

```clojure
(stop-server)
```

The start and stop will look something like this.

![Spacemacs - CIDER REPL - httpkit server start and stop](/images/spacemacs-cider-repl-httpkit-server-start-stop.png)


## Summary

This should demonstrate how relatively simple it is to create a web server in Clojure that can handle 600,00 concurrent requests.

This simple project can be extended to make the web server respond to different requests, based on the web address and type of the HTTP request (e.g. GET, POST).  As more features are added, tests should be written to ensure those features work correctly.

Adding specifications is a clean way to ensure a robust API service, checking the type of information being sent and received is of the correct form. `clojure.alpha.spec` and `pulmatic/schema` are two libraries that will provide this kind of checking.

---
Thank you.

[:globe_with_meridians: Practical.li Website](https://practical.li){target=_blank .md-button}

[:fontawesome-brands-github: Practical.li GitHub Org](https://github.com/practicalli){target=_blank .md-button}
[:fontawesome-brands-github: practicalli-johnny profile](https://github.com/practicalli-johnny){target=_blank .md-button}

[:fontawesome-brands-mastodon: @practicalli@clj.social](https://clj.social/@practicalli){target=_blank .md-button}
[:fontawesome-brands-twitter: @practical_li](https://twitter.com/practcial_li){target=_blank .md-button}
