---
title: "Clojure CLI tools - To jack-in or connect, that is the question"
date:
  created: 2020-12-31
  updated: 2020-12-31
authors:
  - practicalli
categories:
  - clojure
tags:
  - clojure
  - api
draft: true
---

!!! QUOTE "To jack-in or connect, that is the question"
    _Whether it is more effective to relying on the editor to auto-inject the required dependencies for every workflow, or assemble your own aliases them include any editor_ - William "Hacker" Shakespear

A REPL is the central part of Clojure development, providing instant feedback as code is created and tested within an editor.

The REPL process can be started via the `clojure` command line tool, either directly in a terminal or via a `jack-in` command provided by the editor.

The REPL startup can be configured with aliases to include development time paths, libraries and tools.  Including a custom `user` namespace on the path can provide even greater customisation of the REPL startup.

Cider, Conjure and Calva are editor plugins that support the jack-in and connect approaches.

Lets discuss the value and constraints for each approach, particularly in respect to the Clojure CLI tools.

<!-- more -->

??? HINT "Fallback plan - know how to run a REPL in a Terminal"
    When jack-in is failing but the REPL can be run in a terminal then this narrows down issues to the editor and/or plugin.

    If jack-in is failing and the REPL will not start either, then it is likely to be an issue with the Project code or configuration.

    If jack-in and terminal REPL are failing on a minimal project, then its likely its a `clojure` or `java` tool issue.



<!-- A robust and flexible way to run the REPL is via the command line, with an editor establishing a connection to that REPL process over a network protocol (nREPL, SocketREPL).  When starting the REPL, library and middleware should be included in the command. -->

<!-- To simplify the process, editors use a jack-in operation which assembles a command to start a REPL in an external process.  This editor injects dependencies the editor requires to connect to the external REPL.  Once the REPL is running, the editor automatically connects to it. -->


## Terminal REPL and Editor Connect

Using the connect approach gives you full control over how the REPL is run and which other tools and dependencies to include.  There is also no concern about aliases clashing with any automatically injected configuration by the editor.

Running the REPL process outside of an editor ensures that process is not affected by the editor being closed or crashing, making for a more robust REPL process that can be run for a considerable time.  Its also possible to connect to the same REPL process from different [:fontawesome-solid-book-open: Clojure editors](https://practical.li/clojure/clojure-editors/){target=_blank}

An external REPL can also be run in a local container (Docker, ContainerD, VirtualBox) or a remote container / server in a public / private cloud, company data center.

When editors connect to a REPL they are connecting to a server process, such as nREPL server (the most common), Socket REPL server or pREPL.  For nREPL this requires configuration that will include the library and namespace to run the nREPL server.  Socket REPL is part of the Clojure standard library, so does not require a library, only configuration to start the socket server.

> The connect approach requires library versions to be kept up to date with those used by the chosen editor. [:fontawesome-solid-book-open: Practicalli Clojure CLI Config](https://practical.li/clojure/clojure-cli/practicalli-config/){target=_blank} user level configuration includes the `:project/outdated` alias that will report current and new versions of libraries available.

Running more than just a REPL eg. a data inspector such as Portal or Reveal, is a simple matter of ensuring the aliases are included in the appropriate order. The `:main-opts` from the last alias in the chain will be used to run the `-main` function.

As you control the options used with the `clojure` command, well craft aliases can be added to a specific project in `deps.edn` file.  Practicalli also recommends crafting common tasks and tools within the `~/.clojure/deps.edn` configuration file.  Adding aliases to the `~/.clojure/deps.edn` configuration ensures saves duplication and simplifies each project `deps.edn` configuration.

For example, when a user level configurations include aliases for a specific tools or REPL communication protocols then they can be used over and over again for each project under development.

So the connect approach provides a clean and flexible approach to running a REPL, optionally with additional tools, in various local and remote environments and without relying on hidden magic from an editor that could cause issues.

[:fontawesome-solid-book-open: Practicalli Clojure CLI Config - user aliases](https://practical.li/clojure/clojure-cli/practicalli-config/){target=_blank .md-button}

* `:repl/nrepl` - a headless REPL process for use with an editor
* `:repl/rebel` -  a rich terminal UI with REPL process and nREPL server for Clojure editors to connect to
* `repl/reloaded` - as above with Portal data inspector listening to nREPL evaluation results. Used with a `dev/user.clj` file to launch portal on REPL startup.


## Jack-in

The `jack-in` approach is where the editor configures how the REPL is started, by defining the `clojure` command line that will run externally. Once the nREPL server process for the REPL has started, the editor automatically connects.

The connected editor can evaluate code from the source code file in the REPL.

The jack-in approach minimizes the setup required by the developer to get started.

The `clojure` command jack-in uses to start the REPL can be configured, either by directly editing the command before running or by seting environment variables in a `.dir-locals.el` file.

!!! INFO "Jack-in term from William Gibson"
    "jack into cyberspace" was coined by [Willaim Gibson](https://en.wikipedia.org/wiki/William_Gibson) in cyberpunk novels from 1980s, Neuromancer, Count Zero and Mona Lisa Overdrive.

    The term morphed into "jack-in" as Clojure specific tooling was created.  So it is common to say jack-in to the REPL to start and connect to a Clojure REPL process.

### Cider jack-in

Cider uses the following form when assembling the jack-in command

```
[nREPL] Starting server via /usr/local/bin/clojure -Sdeps '{:deps {nrepl/nrepl {:mvn/version "0.8.3"} cider/cider-nrepl {:mvn/version "0.25.5"}}}' -m nrepl.cmdline --middleware '["cider.nrepl/cider-middleware"]'
```

Aliases can be included via an Emacs variable called `cider-clojure-cli-global-options` inside a `.dir-locals.el` file.  Alias names can come from the user level configuration and the project deps.edn configuration.

```elisp
((clojure-mode . ((cider-preferred-build-tool . clojure-cli)
                  (cider-clojure-cli-aliases . ":dev/env"))))
```

cider then builds a command line including the alias


When including an alias in the global-options that defines a `:main-opts` a conflict will arise as cider will build a command line with more than one `-main` function to run.  This may prevent the jack-in process from working.  A simple solution to this is to include an alias that has the same configuration that cider auto-injects.  `practicalli/clojure-deps-edn` configuration contains the `:middleware/cider-clj` alias that contains the cider auto-injected configuration.

Running jack-in with global-opts set to `-M:alias:alias-with-main:middleware/clojure-clj` will ensure that the clojure command calls the `-main` to run the REPL regardless of `:main-opts` defined in the other aliases.  The `clojure` command will use the `:main-opts` only from the last alias in the chain.

```
[nREPL] Starting server via /usr/local/bin/clojure -Sdeps '{:deps {nrepl/nrepl {:mvn/version "0.8.3"} cider/cider-nrepl {:mvn/version "0.25.5"}}}' -M:alias:alias-with-main:middleware/clojure-clj -m nrepl.cmdline --middleware '["cider.nrepl/cider-middleware"]'
```

It is possible to disable almost all of the configuration that Cider automatically injects by using the following `.dir-locals.el` file.  The clojure command line with then run just the configuration form the aliases.  This is useful to start the REPL and connect to the project using jack-in whilst having full control over the functionality.


## Conjure approach

The approach in Conjure is as simple as opening Neovim with a Clojure project.  If a REPL is already running for that project, determined by checking for a port value in the file `.nrepl-port`, then Conjure will connect automatically.

<!-- The Conjure jack-in approach... TODO -->


## Calva jack-in

The Calva jack-in process is similar to Cider although it does not support a `.dir-locals.el` configuration.  Calva does provide an options menu to choose aliases from the project `deps.edn` file.


The standard jack-in command created is of the form

Executing task: clojure -Sdeps '{:deps {nrepl {:mvn/version "0.8.2"} cider/cider-nrepl {:mvn/version "0.23.0"} clj-kondo {:mvn/version "2020.04.05"}}}'  -m nrepl.cmdline --middleware "[cider.nrepl/cider-middleware]"

```
/bin/zsh '-c', 'clojure -Sdeps '{:deps {nrepl {:mvn/version "0.8.2"} cider/cider-nrepl {:mvn/version "0.23.0"} clj-kondo {:mvn/version "2020.04.05"}}}' -m nrepl.cmdline --middleware "[cider.nrepl/cider-middleware]
```

When including aliases in the jack-in command, Calva will add them before the `-m` flag in the Clojure command

```
/bin/zsh '-c', 'clojure -Sdeps '{:deps {nrepl {:mvn/version "0.8.2"} cider/cider-nrepl {:mvn/version "0.23.0"} clj-kondo {:mvn/version "2020.04.05"}}}' -A:env/dev:inspect/portal -m nrepl.cmdline --middleware "[cider.nrepl/cider-middleware]
```

> Note: Calva will use the `-M` flag in a future release when including aliases, moving away from the deprecated `-A` flag in Clojure CLI tools.


### User aliases

Define a `repl.connectSequence` configuration to use one or more aliases from a user level configuration (e.g. `~/.clojure/deps.edn`).

A `repl.connectSequence` is defined in the VS Code editor `settings.json` file.

During the jack-in process, select the name of the connection sequence, rather than Clojure CLI, to start the REPL process with just the aliases from the connectSequence.  It is not possible to select additional alias names from the project deps.edn.

```json
    "calva.replConnectSequences": [
        {"name": "Inspect Portal",
         "projectType": "Clojure CLI",
         "cljsType": "none",
         "menuSelections": {
            "cljAliases": [
               "env/dev",
               "inspect/portal"]}}],
```

The repl.connectSequence adds an extra layer of indirection to the jack-in approach and is not as flexible as using connect.

> There seems to be an issue using kebab-case alias names with a repl connect sequence







Depending on how the editor assembles the clojure command line, it can cause issues running the REPL process when trying to use additional aliases, especially when alias design is conflated by including `:main-opts` configuration.


Configuring jack-in with `:extra-paths` and `:extra-deps` is simple.  However, adding in tools such as data browsers or anything with a :main-opts can conflict with the automatic jack-in process.


## Summary

For simple projects and local environments, using jack-in is a quick way to run a REPL.

You should consider using `connect` if you want a more robust REPL, that can work with local and remote environments, can be accessed by any Clojure editor and can provide more services that just the REPL service (e.g. data visualization tools)


---
Thank you.

[:globe_with_meridians: Practical.li Website](https://practical.li){target=_blank .md-button}

[:fontawesome-brands-github: Practical.li GitHub Org](https://github.com/practicalli){target=_blank .md-button}
[:fontawesome-brands-github: practicalli-johnny profile](https://github.com/practicalli-johnny){target=_blank .md-button}

[:fontawesome-brands-mastodon: @practicalli@clj.social](https://clj.social/@practicalli){target=_blank .md-button}
[:fontawesome-brands-twitter: @practical_li](https://twitter.com/practcial_li){target=_blank .md-button}
