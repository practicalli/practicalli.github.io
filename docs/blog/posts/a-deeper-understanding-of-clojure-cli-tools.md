---
title: A deeper understanding of Clojure CLI
authors:
  - practicalli
date:
  created: 2019-07-21
  updated: 2019-07-21
draft: false
categories:
  - clojure-cli
tags:
  - clojure-cli
draft: true
---


![Practicalli Clojure Logo](https://github.com/practicalli/graphic-design/blob/live/topic-images/clojure-logo-name.png?raw=true){align=right loading=lazy style="width:240px"}

Clojure CLI is a simple and data driven tool for running Clojure projects and tools.

Library dependencies are defined using Maven style release or GitHub Repositories, balancing speed and stability in the development life-cycle.

The CLI is intentionally focused on these fundamental tasks. The CLI build library provide a programmatic approach to building Clojure assets, for example an Uberjar for deployment of a web service.

> Update: CLI REPL was released at the end of 2026 to provide a terminal REPL with nREPL support and built-in data inspector

Community tools extend the Clojure CLI capability, either by defining an alias or installing as a Clojure tool.


The Clojure CLI provide a minimal but elegant layer on top of the `java` command and enables libraries, configuration and code to compose together just like Clojure functions.

Lets dig a little deeper under the covers to understand how they work.

> Additional content can be found in the [Clojure CLI section of Practicalli Clojure](http://practical.li/clojure/clojure-cli/){target=_blank}

<!-- more -->


## Under the covers of CLojure CLI

Using the command `lein new app classic` creates a simple project called `classic` containing some source code and test code. We can use `lein repl` to give instant feedback on the evaluation of the code in our project.

This command also compiles our code to Java bytecode, so it can run on the JVM just like compiled Java or Scala code.

`lein jar` and more commonly `lein uberjar` is used to package up our code into a single file. These commands compile the Clojure code into classes when Ahead Of Time compilation is used.

Any namespaces with `(:gen-class)` directive are compiled into a JVM bytecode class. `lein uberjar` creates a single file that contains the application and the Clojure library, which can be called via the `java` command

`java -cp target/myproject-standalone.jar`

If I had created a library project, with `lein new classic`, then I would need to specify clojure.main and the main class for the `java` command to work correctly.

`java -cp target/myproject-standalone.jar clojure.main -m classic.core`


It is also possible to run the compiled source code, however, we will also need to add Clojure as a dependency. There is a copy of the Clojure library in my maven cache from previous projects I have worked on.

`java -cp target/uberjar/classes/:/home/jr0cket/.m2/repository/org/clojure/clojure/1.8.0/clojure-1.8.0.jar classic.core`


If I just wanted to run a repl, I can call clojure.main as my namespace

`java -cp /home/jr0cket/.m2/repository/org/clojure/clojure/1.8.0/clojure-1.8.0.jar clojure.main`

As your project gets bigger the command become harder to manage safely.

The command is often used in a script to ensure repeatability.

`java $JVM_OPTS -cp target/todo-list.jar clojure.main -m todo-list.core $PORT`


## Clojure CLI

CLI tools project only requires a `deps.edn` file.

`~/.clojure/deps.edn` is created the first time you run the `clojure` command.

A default `deps.edn` file comes with the CLI tools install, e.g. `/usr/local/lib/clojure/deps.edn` on Linux. This file contains a few basic options that are applied to all projects.

`src` is set as the relative path to the source code

The dependencies include `1.12.0` version of the Clojure library.

Aliases define additional libraries that will only be included during development, e.g. `:deps` which provides extra features

Maven central and Clojars are repositories containing Clojure Library Dependencies which the Clojure CLI downloads them from.

```clojure
{
  :paths ["src"]

  :deps {
    org.clojure/clojure {:mvn/version "1.12.0"}
  }

  :aliases {
    :deps {:replace-paths []
           :replace-deps {org.clojure/tools.deps.cli {:mvn/version "0.11.72"}}
           :ns-default clojure.tools.deps.cli.api
           :ns-aliases {help clojure.tools.deps.cli.help}}
    :test {:extra-paths ["test"]}
  }

  :mvn/repos {
    "central" {:url "https://repo1.maven.org/maven2/"}
    "clojars" {:url "https://repo.clojars.org/"}
  }
}
```


## A simple project configuration


```clojure
{:paths ["src"]

 :deps
 {org.clojure/clojure {:mvn/version "1.12.0"}}

 :aliases
 {:test {:extra-paths ["test"]
         :extra-deps {io.github.cognitect-labs/test-runner
                       {:git/tag "v0.5.1" :git/sha "dfb30dd"}}
         :main-opts ["-m" "cognitect.test-runner"]
         :exec-fn cognitect.test-runner.api/test}}```



Dependencies from a Git repository are automatically downloaded and built, within a directory called `~/.gitlibs`.


## Test Driven Development

Create a new file in the `test` directory called `core_test.clj` that contains a test with two assertions.

The `clojure.test` namespace is included in the `org.clojure/clojure` dependency, so we do not have to add anything to the `deps.edn` file

```clojure title="test/practicalli/simple_test.clj"
(ns practicalli.simple-test
  (:require [practicalli.simple :as simple]
            [clojure.test :refer [deftest testing is]]))


(deftest core-tests
  (testing "The correct welcome message is returned"
    (is (= (simple/-main)
           "Hello World!"))

    (is (= (simple/-main "Welcome to the Clojure CLI")
           "Hello World, welcome to the Clojure CLI"))))
```

Run the failing tests with the following command

```shell-session
clojure -X:test

Checking out: https://github.com/cognitect-labs/test-runner.git

Running tests in #{"test"}
Syntax error compiling at (practicalli/simple_test.clj:8:26).
No such var: sut/-main

Full report at:
/tmp/clojure-3370388766424088668.edn
```

The first time the test-runner is run, the CLI tools download the source code from the Git repository.

> NOTE: Using a Git SHA commit to specify a dependency can provide a stable dependency. Any future commit, even a  forced commit created different SHA hash value, preventing a future commit being run in error.


## And now some code

The tests are failing because we have not written the code that the test calls.

Write the functions that are being tested so the test passes when executing the test runner again.

```clojure
(ns practicalli.simple)

(defn -main []
  (println "Hello world"))
```


## Extra dependencies


## Over-ride

Use different versions of dependencies in your project that is set globally.  One example is if you are actively building a project, you may want to include the latest commit on a feature branch.  Or you may be using a third party library and want to test out a new beta version.  Or perhaps you are releasing a library and want to test it with earlier versions of Clojure, for example.


## JVM options

Passing options to the Java Virtual Machine can shape the performance dynamics of your Clojure application.

Limited memory allocation can grind the application to a halt.

I experienced this with a third party Java project, they only had 512Mb as the memory allocation size and after a number of uses we working with it then it would steadily grind to a halt.  Doubling the JVM memory allocation made the application fly for hundreds of concurrent users.


## ClojureScript configuration

`:output-dir` defines where the resulting JavaScript file is written too when compiling ClojureScript.

This is used for a different build, e.g. `deploy` to


## Deployment

Clojure is packaged into a Java Archive (JAR) file, essentially a Zip file of the Clojure project.

To simplify deployment, the Clojure standard library is included in the JAR and referred to as an Uberjar.


!!! EXAMPLE "Clojure Service Uberjar Build Tasks"
```clojure title="build.edn"
(defn clean
  "Remove a directory
  - `:path '\"directory-name\"'` for a specific directory
  - `nil` (or no command line arguments) to delete `target` directory
  `target` is the default directory for build artefacts
  Checks that `.` and `/` directories are not deleted"
  [directory]
  (when
   (not (contains? #{"." "/"} directory))
   (build-api/delete {:path (or (:path directory) "target")})))

(defn uberjar
  "Create an archive containing Clojure and the build of the project
  Merge command line configuration to the default project config"
  [options]
  (let [config (merge project-config options)
        {:keys [class-directory main-namespace project-basis uberjar-file]} config]
    (clean "target")
    (build-api/copy-dir {:src-dirs   ["src" "resources"]
                         :target-dir class-directory})

    (build-api/compile-clj {:basis     project-basis
                            :class-dir class-directory
                            :src-dirs  ["src"]})

    (build-api/uber {:basis     project-basis
                     :class-dir class-directory
                     :main      main-namespace
                     :uber-file uberjar-file})))
```


[Package Projects With Clojure CLI Build](https://practical.li/clojure/clojure-cli/projects/package/tools-build/){target=_blank .md-button}


## Running

To run a generated jar file, clojure must be installed on the deployed server and available on the Java class path.

```shell
java -cp simple.jar clojure.main -m simple.core
```

To run a generated Uberjar file, only the `java` command is needed.

```shell
java -jar service-uberjar.jar
```

---
Thank you.

[:globe_with_meridians: Practical.li Website](https://practical.li){target=_blank .md-button}

[:fontawesome-brands-github: Practical.li GitHub Org](https://github.com/practicalli){target=_blank .md-button}
[:fontawesome-brands-github: practicalli-johnny profile](https://github.com/practicalli-johnny){target=_blank .md-button}

[:fontawesome-brands-mastodon: @practicalli_johnny](https://mastodon.social/@practicalli_johnny){target=_blank .md-button}
[:fontawesome-brands-twitter: @practical_li](https://twitter.com/practcial_li){target=_blank .md-button}
