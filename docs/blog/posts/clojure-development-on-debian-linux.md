---
title: Clojure Development on Debian Linux
date:
  created: 2024-03-02
  updated: 2024-03-02
authors:
  - practicalli
categories:
  - linux
tags:
  - clojure
  - debian-linux
draft: true
---



![Practicalli Debian Linux Logo](https://github.com/practicalli/graphic-design/blob/live/topic-images/debian-linux-logo-name.png?raw=true){align=right loading=lazy style="width:240px"}

Debian Linux is one of the original and longest running Linux distributions, in large part due to the excellent `deb` package management system and the openness of the contribution process.

Debian has inspired a large number of other Linux distributions, most notably Ubuntu.

Debian provides a highly flexible and stable operating system to build a Clojure development environment upon.  Start with a minimal install that uses very few resources and use meta-packages to quickly add major pieces, including a desktop environment of your choice.

> Practicalli Clojure book details more options for [:fontawesome-solid-book-open: Clojure Install](https://practical.li/clojure/install/){target=_blank} and supporting tools

<!-- more -->

## Install Debian

![Practicalli Debian Linux Logo](https://github.com/practicalli/graphic-design/blob/live/topic-images/debian-linux-logo-name.png?raw=true){align=right loading=lazy style="width:120px"}

[:globe_with_meridians: Download the Debian Net install](https://www.debian.org/) minimal ISO image and write to a USB memory stick (flash drive).

> Debian Net install ISO contains the essential debian packages to run a minimal Linux system.  Additional packages are installed via an internet connection to a local mirror.

Insert a USB memory stick and use `df -h` to see its location, e.g. `/dev/sda`

Copy the debian image to the USB stick

```shell
cp debian-12.9.0-amd64-netinst.iso /dev/sda
```

Restart the computer, selecting the USB memory stick to boot from.

Follow the Debian Install Wizard to configure the name of the computer & user accounts, how to connect to the internet an selecting additional software collections as required.  Specific packages and collections can be added at any time after the install has completed.

Select one of the suggested desktop environments, or skip and install [:globe_with_meridians: Regolith Desktop](#regolith-desktop) for an excellent tiling window manager.

??? INFO "Debian Install - Software Selection"
    ![Debian Install - Software selection](https://github.com/practicalli/graphic-design/blob/live/os/debian/debian-install-software-selection.png?raw=true)

    The `tasksel` allows selection of collections at any time after the install has completed.

    ![Debian Install - Software selection](https://github.com/practicalli/graphic-design/blob/live/os/debian/debian-install-tasksel-software-collections.png?raw=true)

### Accounts & passwords

The install will prompt for a root user password and ask for a user account name and password.  Ensure these are securely saved as they are created, e.g. in a password manager.

!!! INFO "A good password approach"
    Passwords should be simple for the user to remember but very hard for people and computer algorithms to guess.

    Using 4 unrelated words that have meaning to only the user provides a convienence password for the user that is very hard to crack, e.g. `crab potato wallpaper spinach`


[Debian Installation Guide](https://www.debian.org/releases/stable/installmanual){target=_blank .md-button}


## Administration commands

![Practicalli Debian Linux Logo](https://github.com/practicalli/graphic-design/blob/live/topic-images/debian-linux-logo-name.png?raw=true){align=right loading=lazy style="width:120px"}

Debian requires administrative tasks such as installing software to be carried out by the root user.

??? INFO "Sudo considered less secure"
    Debian maintainers decided using the `sudo` command to temporarily elevate a user permissions added more of a security risk than using a dedicated root administration account.  If sudo is ever hacked then it opens up the system.

    Using `su -` instead does require remembering two different passwords, although significantly improves security.

    The `sudo` package is in the Debian repository should that approach be preferred.  Once the `sudo` package is installed, add the account name(s) to the sudo group using `adduser`.

    ```shell
    su --login && \
    apt install sudo && \
    adduser account-name sudo
    ```


`su -` switches to the root user account (first prompting for the root password).

`apt` is the advance package tool that manages the install (and removal) of debian packages.

`apt install package-name` installs the specified package along with any packages it depends upon.  Recommended packages are also suggested (documentation or related packages).

`apt update` will update the list of available packages from all repositories.

`apt upgrade` installs the latest versions of packages and is typically run after `apt update`.

`apt dist-upgrade` safely updated packages when there is a new major release of Debian.

`apt search package-name` will search for the package-name provided.

`apt show package-name` displays details of the package, including the available version and any dependant packages

[:globe_with_meridians: Debian package search](https://www.debian.org/distrib/packages){target=_blank .md-button}


## Additional Software

Contrib and nonfree repositories provide additional packages, such as fonts, codecs, etc.

Open **Software & Updates** and unlock the wizzard using the root account password.

Add contrib and non-free repositories, then **Close** and select **Refresh** to update the list of available packages.

![Debian Linux - software repositories contrib and nonfree](https://github.com/practicalli/graphic-design/blob/live/os/debian/debian-software-updates-repositories-contrib-nonfree.png?raw=true)


## FreeDesktop XDG config standard

Using the XDG standard for simplifies maintenance and backup for configuration files and local caches.

All configuration files and directories reside under a `$HOME/.config` directory and do not need to be hidden dot files (or directories).

For example, Clojure configuration is in `$HOME/.config/clojure/` rather than `$HOME/.clojure/`

[:fontawesome-solid-book-open: Debian Linux - XDG FreeDesktop Configuration](https://practical.li/engineering-playbook/os/debian-linux/#root-vs-sudo){target=_blank .md-button}

[:fontawesome-solid-book-open: Adopting FreeDesktop XDG standard for configuration files](https://practical.li/blog/freedesktoporg-xdg-standard-for-clojure-development-tools/){target=_blank .md-button}


## Regolith Desktop

[Regolith Desktop](https://regolith-desktop.com/) is a tiling desktop that is keyboard driven and has minimal resource use.

![Regolith Desktop - example with Chrome and Neovim editor](https://github.com/practicalli/graphic-design/blob/live/os/regolith/regolith-desktop-example-chrome-astronvim.png?raw=true){loading=lazy}

Install Regolith Desktop using the following commands as root user, i.e `su -`.

Register the Regolith public key

```shell
wget -qO - https://regolith-desktop.org/regolith.key | \
gpg --dearmor | sudo tee /usr/share/keyrings/regolith-archive-keyring.gpg > /dev/null
```

Add the regolith package repository to install packages from

```shell
echo deb "[arch=amd64 signed-by=/usr/share/keyrings/regolith-archive-keyring.gpg] \
https://regolith-desktop.org/release-3_1-debian-bookworm-amd64 bookworm main" | \
tee /etc/apt/sources.list.d/regolith.list
```

Update available packages list and install regolith desktop along with a theme, e.g. Gruvbox.

```shell
apt update && \
apt install regolith-desktop regolith-session-flashback regolith-look-gruvbox
```

This command will install a significant number of supporting packages to run a graphical desktop.

`reboot` command to restart Debian Linux once all packages are installed.  A graphical login will display once Debian has rebooted.

[Regolith Desktop - Debian install options](https://github.com/practicalli/graphic-design/blob/live/os/debian/debian-install-software-selection.png?raw=true){target=_blank .md-button}


## Kitty terminal

![Kitty Terminal Logo](https://github.com/practicalli/graphic-design/blob/live/logos/kitty-light.png?raw=true){align=right loading=lazy style="height:120px"}

[Kitty terminal](https://sw.kovidgoyal.net/kitty/) provides a fast and easy to configure terminal application, providing an excellent way to run Neovim or Emacs in a terminal.

Open **Terminal** and `su -` to change to the root user account.

```shell
apt install kitty
```

Kitty terminal includes NerdFonts to provide a rich terminal experience, especially when using Neovim.

!!! TIP "Configure & use Kitty"
    [Practicalli Dotfiles - Kitty](https://github.com/practicalli/dotfiles/tree/main/kitty) contains a recommended configuration for kitty.

    [Practicalli Engineering Playbook](https://practical.li/engineering-playbook/command-line/kitty-terminal/) covers Kitty configuration and usage in more detail

## Java

![Java Logo](https://github.com/practicalli/graphic-design/blob/live/logos/java-logo.png?raw=true){align=right loading=lazy style="height:120px"}

Clojure is a hosted language and required the Java Virtual Machine to run.

Install OpenJDK package for the latest stable version, e.g. Java 21

```shell
apt install openjdk-21-sdk
```

> Use `update-alternatives --config java` if multiple Java versions are installed.


## Clojure

![Clojure Logo](https://github.com/practicalli/graphic-design/blob/live/logos/Clojure_logo.svg.png?raw=true){align=right loading=lazy style="width:120px"}

The Linux install script for Clojure CLI will add the `clojure` binary and `clj` wrapper to `/usr/local/bin`, making it available to all users.

Open a **Terminal** and copy/paste these commands to download and run the Clojure CLI installer.

```shell
curl -L -O https://github.com/clojure/brew-install/releases/latest/download/linux-install.sh && \
chmod +x linux-install.sh && \
sudo ./linux-install.sh
```

### Practicalli Clojure CLI Config

The `deps.edn` file in Clojure CLI Config defines `:aliases` for a wide range of community tools which extend the features of Clojure CLI.

Add Practicalli Clojure CLI Config as the user wide configuration to use these tools across all projects.

```shell
git clone git@github.com:practicalli/clojure-cli-config.git $XDG_CONFIG_HOME/clojure
```

The `clojure` command runs clojure code.  Using one or more aliases extends the features of the `clojure` command.

List the available aliases on the command line or review the [Practicalli Config guide](https://practical.li/clojure/clojure-cli/practicalli-config/).

```shell
clojure -X:deps aliases
```

!!! TIP "Creating Clojure projects"
    `:project/create` alias defined in the Practicalli Clojure Config uses deps-new with the Practicalli Project Templates to create production ready project structures with common development and CI tooling support.

## Neovim

![Neovim Logo](https://github.com/practicalli/graphic-design/blob/live/topic-images/neovim-logo-name.png?raw=true){align=right loading=lazy style="width:120px"}

Debian 12 includes Neovim 0.7.2, although Practicalli recommends downloading the [latest Neovim release from GitHub](https://github.com/neovim/neovim/releases/tag/stable).

Move the `nvim.appimage` file to the local bin directory, adding it to the operating system execution path.

```shell
mv nvim.appimage ~/.local/bin/nvim.appimage
```

Create a symbolic link to allow neovim to be run using the command `nvim`

```shell
ln -s ~/.local/bin/nvim.appimage ~/.local/bin/nvim
```


### Treesitter parsers

Install a suitable compiler for the language parsers used by Treesitter in Neovim.

The `cpp` package is installed by default, however it seems `g++` package is also required

```shell
apt install g++
```

### Lint and format tools

Many lint and format tools are available as NPM packages, so `node` and `npm` are required.

Although nodejs and npm are available as debian packages, the `npm` package has a huge amount of dependencies.

Practicalli recommends the [Linux release from the nodejs website](https://nodejs.org/), installing in the local apps directory for the user account for Clojure development (your normal login account).

Extract the downloaded nodejs archive

```shell
tar Jvxf node-v18.17.1-linux-x64.tar.xz
```

Create a local app directory and move the extracted directory there, creating a symbolic link called current (which can be easily changed if a different version of node is required)

```shell
mkdir ~/.local/apps/nodejs/ && \
mv ~/Downloads/node-v18.17.1-linux-x64/ ~/.local/apps/nodejs/ && \
ln -s ~/.local/apps/nodejs/node-v18.17.1-linux-x64 ~/.local/apps/nodejs/current
```

Create symbolic links to the `node` and `npm` binaries within the `~/.local/bin/` directory, placing the binaries on the path.  Using `current` in the link ensures these symbolic links do not need to be updated when switching to another nodejs version.

```shell
ln -s ~/.local/apps/nodejs/current/bin/node ~/.local/bin/node && \
ln -s ~/.local/apps/nodejs/current/bin/npm ~/.local/bin/npm
```


Install neovim npm package to support Neovim nodejs provider.

```shell
npm install neovim
```


## Emacs

![Emacs Logo](https://github.com/practicalli/graphic-design/blob/live/topic-images/emacs-logo-name.png?raw=true){align=right loading=lazy style="width:120px"}

Debian 12 packages Emacs version 28.2, although Emacs 29.1 is the latest stable release.

Practicalli recommends [building Emacs from source](https://practical.li/blog/posts/build-emacs-from-source-on-ubuntu-linux/) as it is a relatively easy task although will take a little time to compile.


## Slack

[Download the .deb file](https://slack.com/intl/en-gb/downloads/linux) from Slack website

`su -` in a terminal to change to the root user account

```shell
apt install /home/practicalli/Downloads/slack-desktop-4.33.90-amd64.deb
```

Slack can be run from the Desktop launcher, e.g. pressing ++super++ and typing `slack`.


---
Thank you.

[:globe_with_meridians: Practical.li Website](https://practical.li){target=_blank .md-button}

[:fontawesome-brands-github: Practical.li GitHub Org](https://github.com/practicalli){target=_blank .md-button}
[:fontawesome-brands-github: practicalli-johnny profile](https://github.com/practicalli-johnny){target=_blank .md-button}

[:fontawesome-brands-mastodon: @practicalli@clj.social](https://clj.social/@practicalli){target=_blank .md-button}
[:fontawesome-brands-twitter: @practical_li](https://twitter.com/practcial_li){target=_blank .md-button}
