---
title: Use the latest Dev Tools on a Stable Debian Linux
date:
  created: 2026-03-29
  updated: 2026-03-30
authors:
  - practicalli
categories:
  - debian
tags:
  - operating-system
  - bash
  - scripting
  - tui
draft: false
---

![Practicalli Debian Linux Logo](https://github.com/practicalli/graphic-design/blob/live/topic-images/debian-linux-logo-name.png?raw=true){align=right loading=lazy style="width:240px"}

I use Debian Linux as it provides a stable and low maintenance operating system, enabling me to focus on getting valuable tasks done.  Package updates are well tested and the `deb` package management system avoid incompatible versions between dependent packages.

The small amount of maintenance is done via the Advance Packaging Tool (Apt), which has a very simple to understand command line, i.e. `apt install`, `apt update`, `apt upgrade` and `apt purge`.

The constraint of a stable operating system is that some of the latest versions of development tools and programming languages may not be available as part of the distributions package manager.

![Bash logo](https://github.com/odb/official-bash-logo/blob/master/assets/Logos/Icons/PNG/128x128.png?raw=true){align=right loading=lazy}

Simple bash scripts were created to install the latest development tools, made effectively one-liner's where the [Download Release Artifacts (DRA)](#github-releases) project could be used. The scripts were very simple even when falling back to `curl` with a few basic Linux commands.

Each shell script installs either an editor, programming language (e.g. Clojure, Rust, Node.js), Terminal UI (TUI) for development or system administration and for a few desktop apps.

- `debian-linux-post-instal.sh` updates all the Debian packages, reading packages to add and remove from a plain text file.
- `dev-tools-install.sh` calls each script to install all the development tools, programming languages, TUI's and desktop app's.

[Practicalli dotfiles - Debian-Linux Scripts](https://github.com/practicalli/dotfiles/tree/main/debian-linux){target=_blank .md-button}

<!-- more -->

## Debian Packages

![Package icon](https://raw.githubusercontent.com/practicalli/graphic-design/9b3c0b0dc968a4db59ea667487cfd0c30861d792/icons/package.svg){align=right loading=lazy style="width:150px"}

I created a simple bash script to add packages for tools and applications I commonly use.

The script reads a list of packages from two text files, one listing packages to add and another listing packages to remove.

Each list is just a text file, making it very easy to maintain.  I keep both lists in alphabetic order so its easy to check which packages will be added or removed.

The post install script also includes the setup of the clipboard package, based on which windowing system is currently used, i.e. X11 or Wayland.

The script also sets `kitty` as the default terminal.  Kitty would already be installed as it is part of the add package list.

Finally the script tidies up packages not required, `autopurge`, and deletes all the downloaded packages, `autoclean`.

> NOTE: A Debian Linux install adds a few packages that I do not wish to use, or replaces packages when I have alternative package preferences. E.g. I remove Evolution as I do not need a local mail server, I also use LightDM rather than GDM3 for the GUI greeter and display manager.


### Package Post Install Script

A `while` loop is used to read through a package list file one line at a time, each time calling the `apt-get` command.

`sudo apt-get --yes --ignore-missing install <package-name>` is used to install each package in turn.

The `--ignore-missing` flag skips a package if it is already installed and at the latest version.

The `--yes` flag automatically confirms the install, even when otherwise prompted to confirm the install of the recommended package dependencies.

> NOTE: `apt-get` is the back-end command used by `apt`, the Debian Linux package manager.  `apt-get` is ideal for use in scripts and has a little less overhead than `apt` itself.

??? EXAMPLE "Debian Linux Post Install Script"
    ```shell
    #!/usr/bin/env bash

    # Batch install Debian Linux packages used by Practicalli
    # Skip packages if they are already installed

    # NOTES:
    # - apt-get backend used as features of apt UI not required for scripts

    # Package lists to process
    add="debian-linux-post-install-packages-add.list"
    purge="debian-linux-post-install-packages-purge.list"

    ## Update available Debian packages
    echo
    echo "# ---------------------------------------"
    echo Update available Debian packages
    sudo apt update
    echo "# ---------------------------------------"
    echo

    # Install additional Debian packages
    while read -r line
    do
      echo "# ---------------------------------------"
      echo Install "$line"
      sudo apt-get --yes --ignore-missing install "$line"
      echo "# ---------------------------------------"
    done < "$add"
    echo

    echo "# ---------------------------------------"
    echo Install System Clipboard tool - X11 or Wayland
    ./clipboard.sh
    echo "# ---------------------------------------"
    echo

    echo "# ---------------------------------------"
    echo Configure Kitty as default terminal
    sudo update-alternatives --set x-terminal-emulator "/usr/bin/kitty"
    echo "# ---------------------------------------"
    echo

    # Remove additional Debian packages
    while read -r line
    do
      echo
      echo "# ---------------------------------------"
      echo Purge "$line"
      echo "# ---------------------------------------"
      echo
      sudo apt-get purge --yes --ignore-missing "$line"
    done < "$purge"
    echo

    echo "# ---------------------------------------"
    echo Uninstall unnecessary Debian packages
    sudo apt-get autopurge
    echo "# ---------------------------------------"
    echo

    echo "# ---------------------------------------"
    echo Remove Debian package files from cache
    sudo apt-get clean
    echo "# ---------------------------------------"
    echo
    ```

## Development tools

![Tools icon](https://raw.githubusercontent.com/practicalli/graphic-design/9b3c0b0dc968a4db59ea667487cfd0c30861d792/icons/tools-icon.svg){align=right loading=lazy style="width:150px"}

I use Neovim and Emacs editors, a range of development tools and several programming languages.

I created a simple bash script for each each development tool.  Each script downloads and installs the binary or AppImage file for that tool.

Where relevant, the script also updates shell completions (for either bash or zsh, depending on which is currently being used).

The following tools are used to simplify the scripts:

- [Download Release Assets (DRA)](https://github.com/devmatteini/dra){target=_blank} downloads the latest stable release from a GitHub repository
- [Uv](https://docs.astral.sh/uv/){target=_blank} to install python packages, using `uv tool install` to avoid the need for a Python virtual environment.
- Curl with a tools specific install script, e.g. Clojure CLI.
- Curl with a little scripting magic as a fall-back

[Practicalli Dotfiles](https://github.com/practicalli/dotfiles/){target=_blank} contains a [debian-linux](https://github.com/practicalli/dotfiles/tree/main/debian-linux){target=_blank} directory with the individual tool scripts organised in sub-directories:

- `app` for desktop applications
- `cli` for command line tools
- `language` for programming languages, e.g. Clojure, Rust, Node.js
- `tui` terminal UI apps used for system administration and supporting development tools


### GitHub Releases

Most development tools and TUI's have binaries or AppImages available from their GitHub Release pages.

[Download Release Assets (DRA) tool](https://github.com/devmatteini/dra){target=_blank} downloads and installs the latest release from the specified GitHub repository.

Unfortunately I cant use DRA to install DRA, so curl is used to download the DRA install script

Alternatively, use curl and a bit of scripting magic to get the URL of the latest Debian package, using curl again to download the Debian package and the Apt package manager to install the downloaded .deb file.

> NOTE: dra runs on Linux (x86_64, armv6, arm64), macOS (x86_64, arm64) and Windows.

??? EXAMPLE "Use Curl to install DRA via its install script"
    ```shell
    #!/usr/bin/env bash

    echo
    echo "# ---------------------------------------"
    echo "DRA - Download Release Assests from GitHub"
    curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/devmatteini/dra/refs/heads/main/install.sh | sudo bash -s -- --to /usr/local/bin


    # Generate shell command completion
    if [[ $SHELL == "/bin/bash" ]]; then
      mkdir -p ~/.local/share/bash-completion/completions/
      dra completion bash > ~/.local/share/bash-completion/completions/dra

    elif [[ $SHELL == "/usr/bin/zsh" ]]; then
      mkdir -p ~/.local/share/zsh-completion
      dra completion zsh > ~/.local/share/zsh-completion/_dra
    else
      echo "Unknown SHELL, Ripgrep completions will not be generated"
      exit
    fi

    echo
    echo "Dra version: $(dra --version)"
    echo "# ---------------------------------------"
    echo
    ```


??? EXAMPLE "Use Curl to install DRA via the Debain package"
    DRA publishes a `.deb` file as part of each release.

    Curl is first used to find the URL of the .deb package from the latest GitHub release.

    Use `apt` the Debian package manager to install the DRA package.

    ```shell
    #!/usr/bin/env bash

    echo
    echo "# ---------------------------------------"
    echo "DRA - Download Release Assests from GitHub"

    DOWNLOAD_URL=$(curl -s https://api.github.com/repos/devmatteini/dra/releases/latest | grep browser_download_url | grep .deb | cut -d '"' -f 4)

    curl -s -L -o ~/tmp/dra.deb "$DOWNLOAD_URL"

    sudo apt install /tmp/dra.deb

    # Generate shell command completion
    if [[ $SHELL == "/bin/bash" ]]; then
      mkdir -p ~/.local/share/bash-completion/completions/
      dra completion bash > ~/.local/share/bash-completion/completions/dra

    elif [[ $SHELL == "/usr/bin/zsh" ]]; then
      mkdir -p ~/.local/share/zsh-completion
      dra completion zsh > ~/.local/share/zsh-completion/_dra
    else
      echo "Unknown SHELL, Ripgrep completions will not be generated"
      exit
    fi

    echo
    echo "Dra version: $(dra --version)"
    echo "# ---------------------------------------"
    echo
    ```

??? INFO "Deconstructing the Debian package Shell Script"

    | Command	| Description |
    | --- | --- |
    | `curl -s https://api.github.com/repos/USERNAME/REPO/releases/latest` |	Fetch latest release data (JSON) from the GitHub repository |
    | `grep browser_download_url`	| Filters JSON output returning only lines including a download URL |
    | `grep .deb` |	Filters URLs to only those that are .deb files |
    | `cut -d '"' -f 4`	| Extract URL from the filtered JSON response |
    | `curl -s -L -o ~/tmp/filename.deb "$DOWNLOAD_URL"` |	Download `.deb` file to specified directory |


DRA can also be used as a TUI to install a specific version of a tool or automatically install the latest version.

![Download Release Assets from GitHub](https://github.com/devmatteini/dra/raw/main/assets/demo.gif){loading=lazy}

### Neovim

DRA is used to download the latest AppImage and install it globally, so I can use `nvim` for the `practicalli` user account and the `root` account for operating system administration.

The script explicitly specifies the AppImage asset, otherwise DRA will extract and install only the `nvim` client and neglects to include the Neovim runtime.

??? EXAMPLE "Install latest stable Neovim AppImage"
    ```shell
    #!/usr/bin/env bash

    # Install the current release version of Neovim from GitHub for all users

    echo
    echo "# ---------------------------------------"
    echo "Neovim hyper-configurable editor - installed for all users"

    # install the nvim.appimage (automatic only installs nvim and not runtime)
    # rename file to `nvim` the standard executable name
    sudo dra download --select nvim-linux-x86_64.appimage --install --output /usr/local/bin/nvim neovim/neovim

    echo
    echo "Neovim version: $(neovim --version)"
    echo "# ---------------------------------------"
    echo ""
    ```

A similar script is used to install a nightly release of the AppImage.

This script specifies `--tag nightly` to get the latest nightly release.

The script installs the AppImage into `~/.local/bin` as it is only needed for the `practicalli` user account, for testing my Neovim configuration.

??? EXAMPLE "Install latest nightly Neovim AppImage"
    ```shell
    #!/usr/bin/env bash

    # Install the pre-release version of Neovim from GitHub, for the current user

    echo
    echo "# ---------------------------------------"
    echo "Neovim hyper-configurable editor"
    echo "- installed only for current user"

    # Install nvim.appimage nightly release tag and rename to nvim-nightly
    dra download --tag nightly --select nvim-linux-x86_64.appimage --install --output ~/.local/bin/nvim-nightly neovim/neovim

    echo
    echo "Neovim pre-release version: $(nvim-nightly --version)"
    echo "# ---------------------------------------"
    echo
    ```

### Emacs

Emacs usually has the latest version available as a Debian package.

For a newer version or to try bleeding features then I compile Emacs from source code, choosing the relevant branch for the version I require.

[Building Emacs from source code](https://practical.li/blog/build-emacs-from-source-on-debian-linux/){target=_blank} takes a few simple steps and can be configured to create a customised set of features and even a custom desktop icon.

!!! TIP "Emacs Plus is recommended for MacOS users"
    [Emacs Plus](https://github.com/d12frosted/homebrew-emacs-plus){target=_blank} is configurable formulae for Homebrew, providing more features and flexibility than Homebrew's own Emacs formulae.

### TUIs

- [Shellcheck](https://github.com/koalaman/shellcheck){target=_blank} static analysis tool for shell scripts ([online tool]())

??? EXAMPLE "Install Shellcheck using DRA"
    ```shell
    #!/usr/bin/env bash

    echo
    echo "# ---------------------------------------"
    echo "Shellcheck - shell script static analysis tool"
    # INFO: Debian Linux currently 0.10.0

    dra download --automatic --install --output ~/.local/bin/ koalaman/shellcheck

    echo
    echo "Shellcheck version: $(shellcheck --version)"
    echo "# ---------------------------------------"
    echo
    ```

### Clojure

The Clojure programming language environment is distributed as a library, packages as a Java Archive (.jar file). The Clojure library is included in Clojure source code projects as a dependency, so any version of Clojure can be used by specifying the version.

The Clojure CLI managed all library dependencies, including the Clojure library.  The Clojure CLI includes the current Clojure library version to simplify getting started.

[Practicalli Clojure CLI Config]() provides additional tools from the Clojure community on top of the Clojure CLI.

The Practicalli script uses the install script provided by the Clojure CLI project, then clones Practicalli Clojure CLI Config.

!!! EXAMPLE "Install Clojure CLI with Practicalli Clojure CLI Config"
    ```shell
    #!/usr/bin/env bash

    # NOTE: run this script after setting up preferred shell, e.g. zsh
    # Pass directory path to install in different location

    echo
    echo "# ---------------------------------------"
    echo "Clojure CLI via official script"

    # Run the Clojure CLI install script for the latest release:
    # https://github.com/Schniz/fnm
    curl -L -O https://github.com/clojure/brew-install/releases/latest/download/linux-install.sh --output /tmp/clojure-cli-install.sh

    echo "Make script executable"
    chmod +x /tmp/clojure-cli-install.sh
    if [ ! $# -eq 0 ]; then
      echo "Installing Clojure CLI in $1"
      /tmp/clojure-cli-install.sh --prefix "$1"
    else
      echo "Install Clojure CLI in /usr/local/bin"
      sudo /tmp/clojure-cli-install.sh
    fi

    echo "Remove install script"
    rm -f /tmp/clojure-cli-install.sh
    echo


    # Move existing config to a backup file
    if [ -d "$XDG_CONFIG_HOME"/clojure ]; then
      echo "Backup Clojure CLI Config from $XDG_CONFIG_HOME/clojure"
      mv "$XDG_CONFIG_HOME"/clojure "$XDG_CONFIG_HOME"/clojure-backup-"$(date +%Y.%m.%d)"
    if [ -d "$HOME"/.clojure ]; then
      echo "Install Clojure CLI Config in $HOME/.clojure"
      mv "$HOME"/.clojure "$HOME"/.clojure-backup-"$(date +%Y.%m.%d)"
    else
      echo "No existing Clojure CLI Config found"
    fi
    echo

    echo "Install Practicalli Clojure CLI Config"
    # Check if XDG_CONFIG_HOME is set
    if [[ -v XDG_CONFIG_HOME ]]; then
      echo "Install Clojure CLI Config in $XDG_CONFIG_HOME/clojure"
      git clone --depth=1 https://github.com/practicalli/clojure-cli-config "$XDG_CONFIG_HOME"/clojure
    else
      echo "Install Clojure CLI Config in $HOME/.clojure"
      git clone --depth=1 https://github.com/practicalli/clojure-cli-config "$HOME"/.clojure
    fi
    echo

    # Verify the Clojure CLI version:
    echo "Clojure CLI Path: $(which clojure)"
    echo "Clojure CLI version: $(clojure --version)"
    echo "# ---------------------------------------"
    echo
    ```


## Python tools

Python packages are installed by default in Debian Linux, as Python is commonly used for scripts.

Practicalli uses a Python based static site generator to create its websites and blogs.

Initially `pip` was used as the Python package manager, creating a Python Virtual Environment to manage package versions.

`uv` is now preferred as static site generators like Zensical can be installed as a tool, negating the need for a virtual environment.

??? EXAMPLE "Install UV Python package manager"
    ```shell
    #!/usr/bin/env bash

    echo "# ---------------------------------------"
    echo "UV python package manager"
    dra download --automatic --install --output ~/.local/bin/ astral-sh/uv

    echo
    echo "Uv version: $(uv --version)"
    echo "# ---------------------------------------"
    echo
    ```

??? EXAMPLE "Install Material for MkDocs Static Site Generator as a tool"
    ```shell
    #!/usr/bin/env bash

    # -----------------------------------------------
    # Python packages as tools (uv)
    # run as user (not root)

    if [ "$(whoami)" = "root" ]
    then
     echo "Run the uv tool install script with your user account. Do not run as root or via sudo"
     exit
    fi

    echo "# ---------------------------------------"
    echo "Install Material for MkDocs as tool with supporting plugins"
    uv tool install --with mkdocs-material --with mkdocs-callouts --with mkdocs-glightbox --with mkdocs-git-revision-date-localized-plugin --with mkdocs-redirects --with mkdocs-rss-plugin --with pillow --with cairosvg mkdocs
    echo "# ---------------------------------------"
    echo
    ```

??? EXAMPLE "Install Zensical Static Site Generator as a tool"
    ```shell
    #!/usr/bin/env bash

    # -----------------------------------------------
    # Python packages as tools (uv)
    # run as user (not root)

    if [ "$(whoami)" = "root" ]
    then
     echo "Run the uv tool install script with your user account. Do not run as root or via sudo"
     exit
    fi

    echo
    echo "# ---------------------------------------"
    echo "Install Zensical - updates if already installed"
    uv tool install zensical --upgrade
    echo
    echo "Zensical version: $(zensical --version)"
    echo "# ---------------------------------------"
    echo
    ```


## Curl

[Curl](https://curl.se/docs/manpage.html){target=_blank} is a very flexible tools for use with API's, including download of files from GitHub and similar services.

`-fsSL` are recommended flags for downloading files.

- `--fail` or `-f` returns error code without saving content
- `--location` or `-L` follow redirects
- `--silent` or `-s` silent mode, don't show progress meter
- `--show-error` or `-S` show error message on failure
- `--output` or `-o` set the output file or directory, `--create-dirs` option creates local directories dynamically and `-`  passes the output to stdout


## Why not just use Arch Linux

I have used 'rolling' distributions and spent 2025 testing out Arch Linux as an alternative operating system.  The initial learning curve was not too steep and getting going only took a weekend.  However, the maintenance burden was much greater and became a continual distraction.

Part of the maintenance headache was using Hyprland which introduced lots of breaking changes and tainted my experience of Arch Linux.

I was using Btrfs to manage rollbacks when the system became unstable, which happened after most updates.  Unfortunately Btrfs failed during a recovery as it ran out of space, even though there was 18Gb of storage available before the restore.

Even when I regularly deleted the Btrfs snapshots there still seemed to be a lot of extra storage being used by the operating system.

After Btrfs restores trashed my operating system a couple of times, I felt it was not worth continuing with Arch Linux.

> NOTE: I could have gone back to i3 or Gnome which are more stable window managers, but then I didn't see any advantage of using Arch Linux over Debian Linux.

I found some core Arch Linux tools confusing. `packman` command options did not feel intuitive and the docs didn't clarify what the flags letters stood for.  If I continued to use Arch Linux I would have wrapped pacman with a shell script or Makefile tasks.

Using the AUR community repository I also found confusing, there are several tools to access AUR and it wasn't clear from the official docs how to add these tools without first getting a tool from AUR (catch 22 scenario).

The AUR community is a big part of adding the latest development tools.  Without the AURA then Arch Linux didn't feel significantly up to date for software development.

Usually the Arch Linux docs are very comprehensive, but can also drowned the reader in options (some outdated) and yet not provide enough guidance or a clear and simple approach.  If you have time, you can learn a lot, but not everything was relevant to me.

I didn't figure out a nice way to manage my SSH Keys in Arch Linux and had to start and configure an SSH agent for each session.  I could have added the Gnome Keyring tools which would have pulled in Gnome desktop which I didnt need.

I am sure Arch Linux meets the needs of many people, but Debian Linux is the ideal operating system for me now that I scripted the install of my preferred tools.

> NOTE: As I have used Debian Linux since 1995 (30 years at time of writing) I have a strong affinity and confidence using it as my operating system.  Debian has never let me down in all that time.

---
Thank you.

[:globe_with_meridians: Practical.li Website](https://practical.li){target=_blank .md-button}

[:fontawesome-brands-github: Practical.li GitHub Org](https://github.com/practicalli){target=_blank .md-button}
[:fontawesome-brands-github: practicalli-johnny profile](https://github.com/practicalli-johnny){target=_blank .md-button}

[:fontawesome-brands-mastodon: @practicalli@clj.social](https://clj.social/@practicalli){target=_blank .md-button}
[:fontawesome-brands-twitter: @practical_li](https://twitter.com/practcial_li){target=_blank .md-button}
