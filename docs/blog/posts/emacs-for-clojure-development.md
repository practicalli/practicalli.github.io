---
title: Emacs for Clojure development
description: How to use Emacs for Clojure development and what are the options for configuration
icon: https://github.com/practicalli/graphic-design/blob/live/topic-images/emacs-logo-name.png?raw=true
status: new
date:
  created: 2025-01-26
authors:
  - practicalli
categories:
  - emacs
tags:
  - debian
  - spacemacs
  - emacs
draft: true
---


![Practicalli Emacs Logo](https://github.com/practicalli/graphic-design/blob/live/topic-images/emacs-logo-name.png?raw=true){align=right loading=lazy style="width:240px"}

[:globe_with_meridians: Emacs]() has been the most 'popular' editor for Clojure development and according to the [:globe_with_meridians: Clojure Survey 2024](https://clojure.org/news/2024/12/02/state-of-clojure-2024) remains well ahead of other [Clojure aware editors](https://practical.li/clojure/clojure-editors/).

Emacs 30 is the current stable release and includes: Eglot LSP client, Tree-Sitter language parser and `package.el` to install packages from Git repositories directly.

Building from source is a convenient way to try Emacs features in advance, especially useful for those maintaining or developing new tools on top of Emacs.

[Emacs 30 key changes](https://www.gnu.org/software/emacs/manual/html_node/efaq/New-in-Emacs-30.html){target=_blank .md-button}

[Emacs 30 Hightlights](https://emacsconf.org/2024/talks/emacs30/){target=_blank .md-button}

[Whats new in Emacs 30 - Mastering Emacs](https://www.masteringemacs.org/article/whats-new-in-emacs-301){target=_blank .md-button}


<!-- more -->

## Install

=== Debian Linux

    Emacs 30 is available in Bookwork (backports) and Trixie (testing) via the `emacs` metapackage.

    !!! NOTE "Install Emacs 30 via Debian Package"
        ```shell
        apt install emacs
        ```

=== MacOS

    [Emacs Plus](https://github.com/d12frosted/homebrew-emacs-plus) is a GNU Emacs formulae for MacOS, providing configurable extra functionality and UI options.

    !!! NOTE "Install Emacs 30 via Emacs Plus Homebrew"
        ```shell
        brew tap d12frosted/emacs-plus && \
        brew install emacs-plus
        ```

    If using Spacemacs as a configuration

    !!! NOTE "Install Emacs 30 via Emacs Plus Homebrew"
        ```shell
        brew tap d12frosted/emacs-plus && \
        brew install emacs-plus --with-spacemacs-icon
        ```

    If using Doom Emacs as a configuration

    !!! NOTE "Install Emacs 30 via Emacs Plus Homebrew"
        ```shell
        brew tap d12frosted/emacs-plus && \
        brew install emacs-plus --with-modern-doom3-icon
        ```



=== Arch Linux


## References

* [Emacs 28.1 whats new](https://www.masteringemacs.org/article/whats-new-in-emacs-28-1) - a very detailed description of new features in Emacs 28.1
* [Ubuntu Emacs LISP team PPA](https://launchpad.net/~ubuntu-elisp/+archive/ubuntu/ppa) - nightly Emacs snapshot builds from the latest Emacs commits
- [Build Emacs from source on Debian Linux](https://practical.li/blog/build-emacs-from-source-on-debian-linux/)

---
Thank you.

[:globe_with_meridians: Practical.li Website](https://practical.li){target=_blank .md-button}

[:fontawesome-brands-github: Practical.li GitHub Org](https://github.com/practicalli){target=_blank .md-button}
[:fontawesome-brands-github: practicalli-johnny profile](https://github.com/practicalli-johnny){target=_blank .md-button}

[:fontawesome-brands-mastodon: @practicalli@clj.social](https://clj.social/@practicalli){target=_blank .md-button}
[:fontawesome-brands-twitter: @practical_li](https://twitter.com/practcial_li){target=_blank .md-button}
