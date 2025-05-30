---
title: Clojure Coding is easy with Neovim
date:
  created: 2025-03-12
  updated: 2025-03-12
authors:
  - practicalli
categories:
  - practicalli
tags:
  - clojure
  - neovim
  - conjure
  - astronvim
draft: true
---

TODO: Add pictures and a video


<!-- more -->

## Install Clojure

Java and Clojure CLI and Practicalli Clojure CLI Config

## Install Neovim

Latest stable Release

## Configure Neovim

Start with Practicalli Astro as your configuration, to give a rich set of (lazy loading) features.

First run of Neovim will install the relevant packages.

## Clojure workflow

Start a REPL in the root of the Clojure project.  The `:repl/rebel` alias also runs an nREPL server which an editor uses to communicate with the REPL process.

```shell
clojure -M:repl/rebel
```

Open a Clojure file from the project with Neovim (or evaluate code from an already open Clojure file)

```shell
nvim src/practicalli/gameboard/service.clj
```

> Or open Neovim, `nvim .` and use `SPC f f` to find a file or navigate the project directory tree with neogit buffer.

Evaluate some Clojure code to connect the editor to the REPL process over nREPL.

++comma+ ++"e"++ ++"b"++ Evaluate the file (buffer)

++comma+ ++"e"++ ++"r"++ to evaluate from the top-level (root) of an expression, e.g. the `ns` expression.

Evaluation results will show inline.

++comma+ ++"e"++ ++"c"++ menu to evaluate results as comments.

++comma+ ++"l"++ ++"t"++ to open the REPL buffer in a tab page and see the whole REPL history.

> NOTE: Code can also be evaluated in the REPL buffer (although its far easier to evaluate the source code buffers).

## Diagnostics and Refactor tools

Clojure LSP is included in the Practicalli Astro configuration, via the Mason plugin which manages LSP servers, DAP servers, lint and format tools.  Mason registry tracks the latest release of each tool.

Warning and Error icons are show in the margin of respective line of code.

++g++ ++d++ jumps to the definition of a function (even those in jar files)

++spc++ ++l++ LSP menu includes code actions, renaming, symbol outlines, etc

!!! TIP "Clojure LSP can also format code"
    Clojure LSP includes cljfmt library to format code using the recommendations in the Clojure Style Guide.


## Running tests

++,++ ++t++ Testing menu has commands to start a test runner over one or more tests evaluated in the REPL.

Practicalli Astro uses Kaocha test runner, although others are easily configured.


## Source Control

The ++spc++ ++"g"++ menu has commands to stage the current hunk or all changes in the current buffer (Git Signs plugin).

Git Signs also shows differences in working copy and committed code.

Neogit (an Emacs Magit clone) and LazyGit clients will stage/unstage, push, pull and rebase code, providing all the common git commands via a terminal UI.

> NOTE: LazyGit binary should be installed and available on the operating system path.

---
Thank you.

[:globe_with_meridians: Practical.li Website](https://practical.li){target=_blank .md-button}

[:fontawesome-brands-github: Practical.li GitHub Org](https://github.com/practicalli){target=_blank .md-button}
[:fontawesome-brands-github: practicalli-johnny profile](https://github.com/practicalli-johnny){target=_blank .md-button}

[:fontawesome-brands-mastodon: @practicalli@clj.social](https://clj.social/@practicalli){target=_blank .md-button}
[:fontawesome-brands-twitter: @practical_li](https://twitter.com/practcial_li){target=_blank .md-button}
