---
title: "Essential tooling for Clojure development"
date: 2024-01-29
authors:
  - practicalli
categories:
  - clojure
tags:
  - clojure
---

![alternative text](https://github.com/practicalli/graphic-design/blob/live/topic-images/clojure-logo-name.png?raw=true){align=right loading=lazy style="width:240px"}

Clojure development benefits from great tooling focused around an editor (or IDE).

Practicalli uses many features of a Clojure aware editor with a bias towards highly effective interaction with the REPL, user actions driven exclusively via the keyboard and an uncluttered user interface.

Practicalli Clojure provides [an overview of Clojure editors](https://practical.li/clojure/clojure-editors/) and the plugins that provide Clojure support, e.g. Emacs, Neovim, VS Code, Pulsar and Sublime.  

??? HINT "Practicalli preferred editors"
    LightTable was the editor used in the early years of learning Clojure as it was simple to use and provided instant feedback as code was typed.

    Once Spacemacs was release, Emacs with CIDER became the predominant editor for many years.

    Treemacs and LSP have matured so [Neovim and Conjure](https://practical.li/neovim/) has been adopted to provide a fast editing environment with streamlined key bindings for Clojure development.


<!-- more -->

## REPL connnection

![Practicalli Clojure REPL concept logo](https://github.com/practicalli/graphic-design/blob/live/clojure/repl-process.png?raw=true){align=right loading=lazy style="height:150px;width:150px"}

Interaction with the REPL is the foundation of highly effective Clojure development. An editor connects to a REPL process via a network repl (nREPL) server process.

Practicalli starts a REPL process in a terminal using the Clojure CLI tool.  

`:repl/rebel` alias is used to run Rebel Readline to provide a rich terminal UI REPL prompt and starts an nREPL server to support an editor connection.

!!! NOTE ""
    ```shell
    clojure -M:repl/rebel
    ```

![Practicalli Rebel Readline rich terminal REPL](https://github.com/practicalli/graphic-design/blob/live/clojure/rebel/clojure-repl-rebel-function-autocomplete-map-dark.png?raw=true)

!!! INFO "Jack-in or Connect"
    The REPL and nREPL processes are started by an editor jack-in command, providing the relevant dependencies and command line options to the Clojure CLI.  The editor automatically connects to the nREPL process.

    The same command can be run in a terminal and once nREPL server is running the editor can be connected.

    Practicalli uses a terminal REPL prompt for longer running processes or as a way to separate logs from evaluation events, e.g. starting components such as web servers.

    Starting the REPL process outside of the editor provides a useful separation of editor and REPL, also allows for a range of editors and other tooling to share the REPL state 

![Practicalli Clojure REPL Workflow](https://raw.githubusercontent.com/practicalli/graphic-design/live/clojure/clojure-repl-workflow-concept.png){align=left loading=lazy}


## Customise REPL starup

The `user` namespace is always loaded during REPL startup, allowing tools and libraries to be included via a `user.clj` file when on the class path.

Clojure development workflows and tools may vary across projects, so customising the REPL starup is highly valuable.

!!! INFO "Aliases for development tools"
    Clojure CLI aliases from project and user level deps.edn to support different configurations and tools when starting the REPL process


The `:dev/env` and `:repl/reloaded` aliases from [Practicalli Clojure CLI Config](https://practical.li/clojure/clojure-cli/practicalli-config/) add the `dev` directory to the class path, loading a custom `user` namespace defined in `dev/user.clj`.  

A [:fontawesome-solid-book-open: custom `user` namespace](https://practical.li/clojure/clojure-cli/repl-startup/) supports the [:fontawesome-solid-book-open: Practicalli REPL Reloaded workflow](https://practical.li/clojure/clojure-cli/repl-reloaded/), launching Portal data inspector listening to all evaluation results and Mulog Tap Publisher sending log events to Portal.


## Evaluate Clojure

Evaluates expressions as they are written, providing qualative feedback on the expected behaviour.

Expressions are evaluated in Source code window with results inline, keeping focus on the code and avoiding the need to switch namespaces in the REPL.  Larger data structures can be sent to a data inspector (Portal, Cider Inspector)

Cleaning up the REPL state 

- Un-evaluate a var to avoid running stale code and tests, e.g. remove def, defn, deftest names from the REPL process

![Practicalli Clojure REPL connected editor](https://github.com/practicalli/graphic-design/blob/live/clojure/clojure-repl-driven-development-clojure-aware-editor.png?raw=true){loading=lazy}


## Structural Editing

Clojure has a highly structured syntax compared to many other languages thanks to its LISP heritage.  Functions are defined and called in expressions using parenthesis, `()`.

Writing and code refactor is enhanced when the editor ensures parenthesis remain balanced, i.e. every opening paren has a closing paren.

[paredit](http://paredit.org/){target=_blank} ensurce balanced parens along with structural refactor commands to change the structure, e.g.

- slurp pulls expressions into the current expression
- barf pushes the current expression out of the surrounding expression

[parinfer](https://shaunlebron.github.io/parinfer/){target=_blank} provides structural editing based on indentation, automatically ensuring parens are ballanced as code is added or changed.  Parinfer doesnt require any commands or key bindings and so can feel more natural.

![Parinfer example](https://storage.googleapis.com/zenn-user-upload/5a7508d12f68-20221206.gif){loading=lazy}


## Maintain REPL State

A Clojure REPL can be very long lived thanks to the stability of the Java Virtual Machine (JVM).  Removing state vars can help avoid a REPL restart, as tools that refresh namespaces and start/stop/restart a Clojure system components.

- refresh changed namespaces of the project in the REPL process, optionally with hook to restart components

For simpler applications, Practicalli loads `clojure.tools.namespace.repl` at REPL starup via a custom `user` namespace to `refresh` stale namespaces in the project and `set-refresh-dirs` to define the directory paths that should be checked for changes (excluding `dev` from the path to avoid reloading tools).

For web services and Clojure projects composed of system components, the [:fontawesome-solid-book-open: Practicalli Service REPL workflow](https://practical.li/clojure-web-services/service-repl-workflow/){target=_blank} is used. The Service REPL workflow uses either [:fontawesome-solid-book-open: donut-party/system](https://practical.li/clojure-web-services/service-repl-workflow/donut-system/){target=_blank} or [:fontawesome-solid-book-open: Integrant & Integrant REPL](https://practical.li/clojure-web-services/service-repl-workflow/integrant/){target=_blank} to manage restarting of components and reloading changed namespaces into the REPL state.

[:fontawesome-solid-book-open: Practicalli Service REPL workflow](https://practical.li/clojure-web-services/service-repl-workflow/){target=_blank .md-button}

[:fontawesome-solid-book-open: donut-party/system](https://practical.li/clojure-web-services/service-repl-workflow/donut-system/){target=_blank .md-button}
[:fontawesome-solid-book-open: Integrant & Integrant REPL](https://practical.li/clojure-web-services/service-repl-workflow/integrant/){target=_blank .md-button}


## Inspecting / Navigating Data

![Practicalli Portal data inspector logo](https://github.com/practicalli/graphic-design/blob/live/logos/practicalli-portal-logo.png?raw=true){align=right loading=lazy style="height:150px;width:150px"}

Many results of evaluating Clojure produce interesting and potentially complex data structures.  Tools for navigating data aid in the understanding of results produced by Clojure code.

Being able to present the results in different ways can add greater meaning and easier consumption of the results, e.g. visual charts to support data science.

- navigate data, especially nested data
- paginate through large data sets without slowing down the tooling 
- inspect results of an evaluation and follow updates after each evaluation

Emacs Cider Inspector is very powerful for paging through large data sets effectively and navigating a complex structure.

Portal can also navigate data and can show data in a range of views to add more meaning support, e.g. http responses for API development, tables & charts for data science, etc...

Practicalli configures Portal to listen over nREPL to all Clojure code evaluations, which will work with all of the Clojure editors.

[:fontawesome-solid-book-open: Portal Data Inspector - Practicalli Clojure](https://practical.li/clojure/data-inspector/portal/){target=_blank .md-button} 


## Creating projects

Creating a  a clojure project from templates can save time and provide a consistent base for an organisation.  Extending project templates with options allows for diversity whist still providing common a approach.

Projects from template are typically created via a shell command, so an editor with shell support is valuable.

[:fontawesome-solid-book-open: Practicalli Project Templates](https://practical.li/clojure/clojure-cli/projects/templates/practicalli/) simplifies Clojure project creation with a growing number of templates, derived from commercial and community experiences.


---
Thank you.

[:globe_with_meridians: Practical.li Website](https://practical.li){target=_blank .md-button} 

[:fontawesome-brands-github: Practical.li GitHub Org](https://github.com/practicalli){target=_blank .md-button} 
[:fontawesome-brands-github: practicalli-johnny profile](https://github.com/practicalli-johnny){target=_blank .md-button}

[:fontawesome-brands-mastodon: @practicalli@clj.social](https://clj.social/@practicalli){target=_blank .md-button}
[:fontawesome-brands-twitter: @practical_li](https://twitter.com/practcial_li){target=_blank .md-button}


<!-- 


#### Debugging tools
* instrument function(s) with break points
* step through functions
* display / inspect local values
* step over calls  

#### Code manipulation features
* Vim style editing (a bias of mine, but definitely worth having)
* Structural Editing (smartparents, paredit - manually driven approach)
* Refactor code (rename, add requires, extract to function / let, 
* Multi-replacement (e.g. Emacs iedit)
  * select all matches in scope, jump between matches, toggle matches and simultaneously edit them
* Narrowing (e.g Emacs narrowing) - view over part of a file, limiting scope of changes
* Multiple cursors

#### Unit Testing
* Support REPL based test runner (e.g. cider-test)
* Support externally running test runner (e.g. kaocha)
* Enable watch for changes to trigger re-run of tests
* Run all tests / namespace tests / single test / only failing test
* support test selectors to run group of tests
* easy to understand test reports 

#### Code archaeology features
* Incoming / outgoing call stack
* Navigate to definition (project, dependency and Java sources where relevant)
* Indicate uses (e.g. number of functions calling a function)
* Indicate unit tests (optional)
* Navigate to errors 

#### Live collaboration
* sharing live code view (Vs code live, floor it's, etc.)
  - VS Code Live is excellent and significant code changes could be done in a separate editor if vscode/calva unfamiliar 

#### General features

* Git client (ideally as rich as Emacs Magit or VS Code edamagit)
* Option to use 100% Keyboard driven interaction (mouse-less operation of tooling) 
* vim-style multi-modal editing
* Clojure LSP support (ideally with customisable client lsp UI elements)


- evaluate a namespace to load all expressions the current namespace and required namespaces, except expressions in `comment` form or `#_`
- evaluate a top-level expression or nested expression (e.g. eval last s-expression)
- option to eval expression within `(comment ...)` and after `#_`

Evaluation to investigate the behaviour of the code

- pretty print the evaluation result or sent to an inspector, i.e. to navigate more interesting data structures
- print evaluation as a comment, preferably with a pretty print option, to demonstrate aspects of a function or support software archaeology
- replace expression with result of evaluation to better understand that part of the code
- macro-expand expression to see what code the macro produces


-->
