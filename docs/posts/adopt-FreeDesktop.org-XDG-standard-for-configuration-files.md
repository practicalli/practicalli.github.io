---
title: FreeDesktop.org XDG standard for Clojure development tools
authors:
  - practicalli
date: 2022-05-16
draft: false 
categories:
  - debian
tags:
  - debian
  - emacs
  - neovim
  - clojure-cli
---

![Debian Linux Logo](https://github.com/practicalli/graphic-design/blob/live/topic-images/debian-linux-logo-name.png?raw=true){align=right loading=lazy style="width:240px"}

The [:globe_with_meridians: FreeDesktop.org XDG basedir standard](https://www.freedesktop.org/wiki/Specifications/basedir-spec/) defines specific locations to store all user configuration, data files and caches.

Without the XDG standard, these files and directories are often mixed together and stored in the `$HOME`  of the users account, making it more challenging to backup or version control.

Development tools such as NeoVim, Emacs, Clojure CLI  and Clojure LSP support the XDG specification, although some tools like Leiningen required a little help.  There are simple approaches to work-around the limitations of tools that don't conform.

<!-- more -->

## FreeDesktop XDG Standards

[FreeDesktop.org](https://www.freedesktop.org/wiki/) produces [standards under the Cross-Desktop Group](https://www.freedesktop.org/wiki/Specifications/), referred to as XDG.

Two of the most relevant specifications for users are:

* [Desktop base directories (basedir)](https://www.freedesktop.org/wiki/Specifications/basedir-spec/): defining the location of application configuration and data files
* [Desktop entries (.desktop)](https://www.freedesktop.org/wiki/Specifications/desktop-entry-spec/): to define executable, application name, icon and description, used by application launchers and desktop menus

This article will focus on the basedir configuration and document the XDG locations for a range of common developer tools


## XDG Environment variables

The XDG Base Directory Specification defines specific environment variables to define each locations, usually set in the configuration file of the operating system shell, e.g. zsh, bash, fish.

Each location contains application specific files within a directory of the same name as that application, e.g. `XDG_CONFIG_HOME/git` for Git version control client.

* `XDG_CONFIG_HOME` user-specific configuration files, default `$HOME/.config`
* `XDG_DATA_HOME` user-specific data files. default `$HOME/.local/share`
* `XDG_STATE_HOME` user-specific state data `$HOME/.local/state`
* `XDG_CACHE_HOME` user-specific non-essential (cached) data, default `$HOME/.cache`
* `XDG_RUNTIME_DIR` runtime files bound to the login status of the user

 `XDG_CONFIG_DIRS` and `XDG_DATA_DIRS` can be used to define an ordered set of directories to search for their respective files, rather than just a single directory.

> Environment variables must be set to an absolute path to be consider valid.  Values can include other environment variables, e.g. HOME, as long as the path resolves as absolute.

A detailed description is covered in [the freedesktop.org basedir specification](https://specifications.freedesktop.org/basedir-spec/latest/ar01s03.html).

??? "MacOSX FreeDesktop.org XDG Standard Paths"
    According to Apple documentation, the XDG Base directory specifications should use these locations

    * `XDG_CONFIG_HOME` -︎ `~/Library/Preferences/` using reverse domain name notation: `com.apple.AppStore.appname`
    * `XDG_DATA_HOME` -︎ `~/Library/`
    * `XDG_CACHE_HOME` -︎ `~/Library/Caches/`

    See the [Mac OS X Reference Library: Where to Put Application Files](http://developer.apple.com/library/mac/#documentation/MacOSX/Conceptual/BPFileSystem/Articles/WhereToPutFiles.html) and [Mac OS X Reference Library: Important Java Directories on Mac OS X](https://developer.apple.com/library/archive/qa/qa1170/)


## Configuring Linux / Unix operating system

The XDG basedir specification is used by many Unix distributions, although the `XDG_CONFIG_HOME` is rarely set as it may break older applications.  Instead the OS uses the default locations in the specifications and expects applications to do the same.

Some tools already use the default location of `XDG_CONFIG_HOME`. Most maintained tools will use the XDG locations if the environment variables are set.

Defining `XDG_CONFIG_HOME` before installing development tools and applications helps ensure that the right locations are used.

Existing configurations are easily migrated to the `XDG_CONFIG_HOME` directory, either all at once or application by application.  If the configuration is not found in `XDG_CONFIG_HOME` the application should look for the configuration in the `HOME` directory.


## Where to Set environment variables

For desktop launchers, edit the `.profile` file and export a value for `XDG_CONFIG_HOME`, which should then be used by all applications launched in this way.

For example, the `XDG_CONFIG_HOME` is defined for all applications and `SPACEMACSDIR` is defined specifically for Spacemacs configuration for Emacs.

```
# Ensure XDG_CONFIG_HOME is set when launching apps from destktop
export XDG_CONFIG_HOME=$HOME/.config

# Application specific
export SPACEMACSDIR=$XDG_CONFIG_HOME/spacemacs


# Recommended locations
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CACHE_HOME=$HOME/.cache
export XDG_STATE_HOME=$HOME/.local/state
```

To apply these environment variables, logout of the desktop environment, then login again.  Now the environment variables are set.

To test before logout/login, in a terminal run the command `source ~/.profile` and the environment variables will be available in that terminal session.

### Command Line

The shell and all command line tools will use environment variables in `~/.profile`.  Or they can be set in the respective resource files for the terminal shell to add environment variables

* bash - use `~/.bashrc`
* zsh - use `~/.zprofile` or `.zshenv`

For example, in `~/.zprofile`:

```
# Set XDG_CONFIG_HOME for clean management of configuration files
export XDG_CONFIG_HOME="$XDG_CONFIG_HOME=$HOME/.config"
```


## Zsh - prezto

[Prezto](https://github.com/sorin-ionescu/prezto) is an rich configuration for Zsh that provides aliases, functions, auto completion and prompt themes (including the popular [Powerline10k theme](https://github.com/romkatv/powerlevel10k)). Prezto includes a wide range of optional modules such as git status, autosuggestions (fish shell completion), GPG, etc.

![Prezto themes - Sorin theme example](https://i.imgur.com/nrGV6pg.png)

Install prezto in the `XDG_CONFIG_HOME/zsh` directory.

```bash
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${XDG_CONFIG_HOME}/prezto"
```

Prezto requires `~/.zshenv` to bootstrap the location of prezto configuration.  The `~/.zshenv` file can be a symbolic link to `XDG_CONFIG_HOME/zsh/.zshenv`

Set the `XDG_CONFIG_HOME` location to `HOME/.config` for all applications if not set in `~/.profile`

Set the `ZDOTDIR` location so Zsh can find the Prezto configuration.

```
# Set XDG_CONFIG_HOME for clean management of configuration files
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:=$HOME/.config}"
export ZDOTDIR="${ZDOTDIR:=$XDG_CONFIG_HOME/zsh}"
```

Other application specific environment variables should be added to `.zshevn` file as well, e.g. `SPACEMACSDIR` for Spacemacs configuration.

> TIP: Once installed, any prezto configuration files that will be added can be copied from the `.zprezto/runcoms` directory to `XDG_CONFIG_HOME/zsh`, rather than linking as the documentation suggests. This approach minimises the need to merge changes when updating prezto.


## Neovim

Neovim supports the XDG basedir specification and will use `~/.config/nvim` directory by default.

All the packages installed, such as the excellent [Conjure](https://github.com/Olical/conjure) for Clojure development (and many other fun languages), will therefore be part of the `~/.config/neovim` configuration.

Vim does not support the basedir.  However, when Neovim is installed as a .deb package it will be used for the vim command (set via `/etc/alternatives/vim`)

> [Practicalli Neovim](https://practical.li/neovim/) is the start of a new book on setting up Neovim with Clojure, LSP, Treesitter and many other packages, using fennel (a lisp dialect) for its configuration.  More details coming soon.


## Emacs and Spacemacs Configuration

Emacs will use `XDG_CONFIG_HOME/emacs` location if it contains an `init.el` file.

`SPACEMACSDIR` environment variable is used by Spacemacs to set the `dotspacemacs-directory`, defining where to look for the Spacemacs specific `init.el` file.

Set `SPACEMACSDIR` to `XDG_CONFIG_HOME/spacemacs`

```
# Ensure XDG_CONFIG_HOME is set when launching apps from destktop
export XDG_CONFIG_HOME="$HOME/.config"

# Ensure Emacs can find the location of Spacemacs configuration
# when using a desktop launcher
export SPACEMACSDIR="$XDG_CONFIG_HOME/spacemacs"
```

Move the `.spacemacs` file to `XDG_CONFIG_HOME/spacemacs/init.el`.  Or if using `~/.spacemacs.d/` then move that directory to be the `XDG_CONFIG_HOME/spacemacs/` directory.


## authinfo secure credentials

Connection credentials that include sensitive data (passwords, developer tokens) can be stored in `authinfo.pgp`, a PGP encrypted file. This providing an extra level of security for sensitive data.

For example, Magit Forge uses authinfo.gpg to define a connection to GitHub or GitLab that includes a developer token.

```
  ;; Use XDG_CONFIG_HOME location or HOME
  (setq auth-sources (list
                      (concat (getenv "XDG_CONFIG_HOME") "/authinfo.gpg")
                      "~/.authinfo.gpg"))
```


## Doom Emacs

If Emacs configuration is detected in `$HOME/.config/emacs` then Doom will install its configuration in `$HOME/.config/doom`, so long as `DOOMDIR` has not already been configured to a different location by the user.


## Git

Git will write to and read from `XDG_CONFIG_HOME/git/config` as its configuration, if that file exists and `~/.gitconfg` does not exist.  Otherwise `~/.gitconfg` is used.

Before running any `git` commands, create a config file in the XDG location

```bash
mkdir  $XDG_CONFIG_HOME/git && touch  $XDG_CONFIG_HOME/git/config
```

`git config` commands will now update the XDG configuration file, e.g. setting the user identity and configure diff to use the diff3 (shared parent) for merge conflicts

```bash
git config --global user.name "John Practicalli"
git config --global user.email "******+account-name@users.noreply.github.com"
git config --global merge.conflictstyle diff3
```

Add an ignore-global file to the `XDG_CONFIG_HOME/git` directory. Example excludes files can be found at [github/gitignore repository](https://github.com/github/gitignore) or at [practicalli/dotfiles](https://github.com/practicalli/dotfiles)

Add an excludes file to the Git config file containing the patterns used across all the users projects.

```
git config --global core.excludesFile ~/.config/git/ignore-global
```

> The git ignore file should be defined with the full path so tools like projectile can find that ignore file.

`XDG_CONFIG_HOME/git/template` is a common location for scripts and hooks that should be added to a newly created Git repository, in the `.git` directory.  The template location is set by `init.templatedir`

```
mkdir  $XDG_CONFIG_HOME/git/template

git config --global init.templatedir template
```


## Clojure CLI

The `XDG_CONFIG_HOME/clojure` directory is the location for the Clojure CLI user level configuration files (e.g. `deps.edn`, `tools/tools.edn`).

If `XDG_CONFIG_HOME` is not set or that location is not found, then `HOME/.clojure` is used instead.

If `CLJ_CONFIG` is set to a value, then Clojure CLI commands will use that instead.

> Also see Maven and dependencies to manage the `$HOME/.m2/repository` directory


## Maven and dependencies

Clojure CLI and Leiningen use the Maven configuration directory to store Jar files from project (and tooling) dependencies, by default this is located in `$HOME/.m2/repository`.

Jar files from dependencies are considered non-essential (to the Clojure CLI tool) so should be written to the $XDG_CACHE_HOME location, typically `$HOME/.cache`

Add the `:mvn/local-repo` top-level key in the user level deps.edn file to set a location for the Maven repository.  The value should be the full directory path.

```clojure
:mvn/local-repo "/home/practicalli/.cache/maven/repository"
```

The `:mvn/local-repo` can also be used in a project deps.edn file or on the command line, i.e. `clojure -Sdeps '{:mvn/local-repo ".cache/temp-deps"}'` if the Maven dependencies should be kept separate from all other projects (this scenario is not common).

The Maven `$HOME/.m2` directory also [contains several configuration files](https://maven.apache.org/configure.html), `maven.config`, `jvm.config` and `extensions.xml`, so unfortunately conflates configuration files with data files.  Although Clojure CLI does not use these configuration files, it is useful to separate the jar files into a cache.


### Clojure Gitlibs

Clojure CLI can used dependencies from Git repositories.  To do so, the repository is downloaded into a `$HOME/.gitlibs` directory, unless the `GITLIBS` environment variable is set.  As the `gitlibs` directory contains data for the application, then ideally this would be placed in `XDG_CACHE_HOME`, under a `clojure-gitlibs` directory

Set the `GITLIBS` environment variable to determine the location of the local cache directory used to clone dependencies that are Git repositories.

```
export $GITLIBS=$XDG_CACHE_HOME/clojure-libs
```

Optionally move the existing `$HOME/.gitlibs` to the Cache home.

```
mv $HOME/.gitlibs $XDG_CACHE_HOME/clojure-gitlibs
```


## Clojure LSP

`XDG_CONFIG_HOME/clojure-lsp` directory is used as the location for Clojure LSP configuration if `XDG_CONFIG_HOME` is set.  Otherwise, `$HOME/.clojure-lsp` is used as the configuration.

> If Clojure LSP was used for for a while, configuration may be in the deprecated `~/.lsp` directory.


## Intellij Idea and Cursive

Intellij Idea from version 2020.1 uses the XDG basdir specification locations without the need to set XDG_CONFIG_HOME.

Configuration is organised under the ~/.config/JetBrains/ directory with product and version sub-directories, for example:

```
~/.config/JetBrains/IntelliJIdea2022.1
```

[Intellij IDEA 2020.1 documentation - configuration directories](https://www.jetbrains.com/help/idea/directories-used-by-the-ide-to-store-settings-caches-plugins-and-logs.html#config-directory)


## Leiningen

Leiningen does not support configuration in `XDG_CONFIG_HOME`, although there is an [outstanding issue to add this as an enhancement from 2016](https://github.com/technomancy/leiningen/issues/2087).

Once Leiningen is installed, a temporary work-around would be to move the `~/.lein` directory to `XDG_CONFIG_HOME/leiningen` and create a symbolic link called `~/.lein`

```
mv ~/.lein $XDG_CONFIG_HOME/leiningen

ln -s $XDG_CONFIG_HOME/leiningen ~/.lein
```

> The `lein` script uses `LEIN_HOME` variable, although this is hard-coded in the script to `$HOME/.lein` and therefore is not usable to set as an operating system environment variable to change the configuration directory location.


## VS Code and Calva

Unfortunately XDG basedir specification is not currently supported by VS Code and therefore Calva (although I assume the Clojure LSP tooling in Calva will use XDG_CONFIG_HOME)

There is an outstanding issue on the VS Code, also from 2016, to [revisit the configuration structure and support XDG_CONFIG_HOME](https://github.com/microsoft/vscode/issues/3884).

Using the symbolic link workaround, as with Leiningen, should work for VS Code too.

```
mv $HOME/.vscode $XDG_CONFIG_HOME/vscode
ln -s $XDG_CONFIG_HOME/vscode $HOME/.vscode
```

> It is advisable to close VS Code before moving the configuration, to ensure the configuration has been saved.


## Summary

The XDG basedir specification makes it simple to back up and version a users configuration files as they are all under the one directory, i.e. `$HOME/.config`

As data and cache files are in different locations, then few if any ignore files are required to version the configuration files.

Migrating is relatively quick and painless and applications can be migrated over time if required.

Thank you

[practicalli GitHub profile](https://github.com/practicalli) I [@practical_li](https://twitter.com/practcial_li)
