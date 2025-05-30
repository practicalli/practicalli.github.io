---
title: A deeper understanding of Clojure CLI tools
authors:
  - practicalli
date: 2019-07-21
draft: false
categories:
  - clojure-cli
tags:
  - tools-deps
  - clojure-cli
draft: true
---


![Practicalli Clojure Logo](https://github.com/practicalli/graphic-design/blob/live/topic-images/clojure-logo-name.png?raw=true){align=right loading=lazy style="width:240px"}

CLI tools make Clojure very accessible and simple to install as they are a essentially a wrapper for running Clojure code using the `java` command and use additional libraries to manage dependencies, class paths, create projects and build java archive (jar) files.

Its quite common to use the `java` command to run your code in production, usually defined in a shell script.  Leiningen can be used to run your application in production too, however, because Leiningen creates 2 JVM instances (one for itself and one for the application), its more efficient to just use the `java` command.

Leiningen does provides a very rich set of templates that speed up development with Clojure and has a multitude of plugins. Plugins provide a rich source of features but they are not very composable, especially compared to the Clojure language itself.

Clojure CLI tools provide a minimal but elegant layer on top of the `java` command and enables libraries, configuration and code to compose together just like Clojure functions.  So we will continuing the exploration of Clojure CLI tools and dig a little deeper under the covers to understand how they work and how to configure projects to be very flexible, especially the different sources of code you can use .

> Additional content can be found in [Using Clojure tools section of Practicalli Clojure](http://practical.li/clojure/clojure-cli/)

<!-- more -->


## Under the covers of CLojure CLI

Using the command `lein new app classic` creates a simple project called `classic` containing some source code and test code.  We can use `lein repl` to give instant feedback on the evaluation of the code in our project.

This command also compiles our code to Java bytecode, so it can run on the JVM just like compiled Java or Scala code.

`lein jar` and more commonly `lein uberjar` is used to package up our code into a single file.  These commands compile the Clojure code into classes when Ahead Of Time compilation is used.  Any namespaces with `(:gen-class)` directive included in compiled into a JVM bytecode class is `lein uberjar` creates a single file that contains our application and the Clojure library, so we can use with the java command line

`java -cp target/myproject-standalone.jar`

If I had created a library project, with `lein new classic`, then I would need to specify clojure.main and the main class for the `java` command to work correctly.

`java -cp target/myproject-standalone.jar clojure.main -m classic.core`


It is also possible to run the compiled source code, however, we will also need to add Clojure as a dependency.  There is a copy of the Clojure library in my maven cache from previous projects I have worked on.

`java -cp target/uberjar/classes/:/home/jr0cket/.m2/repository/org/clojure/clojure/1.8.0/clojure-1.8.0.jar classic.core`


If I just wanted to run a repl, I can call clojure.main as my namespace

`java -cp /home/jr0cket/.m2/repository/org/clojure/clojure/1.8.0/clojure-1.8.0.jar clojure.main`

Already there are a few things to remember. As your project gets bigger then the command you use will get bigger and harder to manage safely, its often put into scripts but then there is no real validation that you got the script right, without some manual testing

`java $JVM_OPTS -cp target/todo-list.jar clojure.main -m todo-list.core $PORT`


## Clojure CLI

CLI tools project only requires a `deps.edn` file.

`~/.clojure/deps.edn` is created the first time you run the `clojure` command.

A default `deps.edn` file comes with the CLI tools install, e.g. `/usr/local/lib/clojure/deps.edn` on Linux.  This file contains a few basic options that are applied to all projects.

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


## Time for some Test Driven Development

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
           "Hello World! Welcome to the Clojure CLI"))))
```

We run the failing tests with the following command

```shell-session
clojure -X:test

Checking out: https://github.com/cognitect-labs/test-runner.git

Running tests in #{"test"}
Syntax error compiling at (practicalli/simple_test.clj:8:26).
No such var: sut/-main

Full report at:
/tmp/clojure-3370388766424088668.edn
```

You can see that the first time we are using the test-runner the CLI tools download the source code from the Git repository.

> NOTE: Using a Git commit provides just a stable dependency as Maven or other tool.  The only risk is if you are using a shared repository and a force commit is made that replaces the commit you have as dependency, but that will have a different hash value, so you will notice that kind of change when running your code.


## And now some code

Everything is working correctly and the tests are failing because we have not written the code that the test is using.  So write the application code and make the test pass and execute the test runner again.

```clojure
(ns practicalli.simple)

(defn -main []
  (println "Hello world!"))
```


## Extra dependencies


## Over-ride

Use different versions of dependencies in your project that is set globally.  One example is if you are actively building a project, you may want to include the latest commit on a feature branch.  Or you may be using a third party library and want to test out a new beta version.  Or perhaps you are releasing a library and want to test it with earlier versions of Clojure, for example.


### Example



## JVM options

Passing options to the Java Virtual Machine can be very important to shape the performance dynamics of your Clojure application.  For example, not enough memory allocation can really grind your application to a halt.  I experienced this with a third party Java project, they only had 512Mb as the memory allocation size and after a number of uses we working with it then it would steadily grind to a halt.  Doubling the JVM memory allocation made the application fly for hundreds of concurrent users.


## Configuration options useful for CLJS

:output-dir to define where the resulting JavaScript file is written too when compiling ClojureScript.  This is used for a different build, e.g. `deploy` to


## Deployment

We saw that Leiningen created a single file that we can use to deploy our application and call from the `java` command line.

TODO: tools-build example


## Running

To run the generated jar file

java -cp simple.jar clojure.main -m simple.core

> depstar does not do any ahead of time compilation (AOT) so your application may start up more slowly as the code first needs to be compiled into Java byte code.

<https://github.com/clojure/clojure/commit/653b8465845a78ef7543e0a250078eea2d56b659>

Thank you.
[@jr0cket](https://twitter.com/jr0cket)
