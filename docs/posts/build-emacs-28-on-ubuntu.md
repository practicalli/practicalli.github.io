---
title: "Building Emacs 28 on Ubuntu Linux"
date: 2022-05-16
authors:
  - practicalli
categories:
  - emacs
---

![Practicalli Clojure Logo](https://github.com/practicalli/graphic-design/blob/live/topic-images/emacs-logo-name.png?raw=true){align=right loading=lazy style="width:240px"}

Emacs 28.1 is [a feature packed release](https://www.masteringemacs.org/article/whats-new-in-emacs-28-1 "What is new in Emacs 28.1") and includes native compilation to significantly increase the speed of all Emacs software packages installed.  This is a very noticeable difference, especially when Emacs is at the center of your developer workflow.

Ubuntu hasn't packaged Emacs 28.1 yet, although its *usually* straight forward to build Emacs yourself.

<!-- more -->

## A very brief summary

```
sudo apt build-dep emacs && /
sudo apt install libgccjit0 libgccjit-10-dev libjansson4 libjansson-dev gnutls-bin
```

[Download Emacs 28 source code](https://www.gnu.org/software/emacs/download.html) and open a terminal in the root of the extracted *emacs28-1* directory

```
export CC=/usr/bin/gcc-10  && export CXX=/usr/bin/gcc-10 && ./autogen.sh && ./configure --with-native-compilation && /
make -j$(proc)  && /
sudo make install
```

Read the rest of the article for a more detailed description


## Prepare Ubuntu

Open `Software & Updates` and ensure the Source Code source is enabled and reload the package list (or run `sudo apt update` in a terminal after adding Source Code)

![Ubuntu Software & Updates - Download from Source Code](https://raw.githubusercontent.com/practicalli/graphic-design/live/ubuntu/screenshots/ubuntu-sofware-updates-download-from-source-code.png)

Ask Ubuntu to install the packages required to build Emacs (there will be quite a few packages if this is the first software built with GCC on the operating system)

```shell
sudo apt build-dep -y emacs
```

> The previous approach was to use `sudo apt-get install build-essential gcc git-core`. Using build-deps manages the set of packages required as Emacs evolves.

Install some additional libraries to support the newest features of Emacs, native compilation of Emacs packages (`libgccjit`) and fast JSON processing (`libjansson`).  These really boost performance, so are important to add.

```shell
sudo apt install libgccjit0 libgccjit-10-dev libjansson4 libjansson-dev
```

> On Ubuntu 20.04 `sudo apt-get install gnutls-bin`  removes a potential issue from an older certificates library


## Preparing Emacs source code

**[Download Emacs 28.1 source from a nearby GNU mirror](https://www.gnu.org/software/emacs/download.html)**, either tar.gz or tar.xz

Extract the source code using nautilus, file-roller or in a terminal with the command `tar zvxf emacs-28.1.tar.xz`

In a terminal window, change into the **emacs28.1** directory

```
cd emacs28-1
```


Set `CC` and `CXX` environment variables to inform the Emacs configuration script as to the location of gcc-10, otherwise it fails to find libgccjit

```
export CC=/usr/bin/gcc-10 && export CXX=/usr/bin/gcc-10
```

> If CC and CXX environment variables are not set, the configure script will not find important libraries and report errors such as: `configure: error: ELisp native compiler was requested, but libgccjit was not found.`


Run the autogen script to create a configure script specific to your operating system.

```
./autogen.sh
```

Run the configuration script with the native compilation flag.  This script will check the operating system for tools and libraries needed to build Emacs on your operating system.

```
./configure --with-native-compilation
```

Check the output of `./configure` was successful, see the end of this article for an example.  Ignore warnings about movemail if not using Emacs for local email management.

> `./configure --help` lists available flags. Generally features are enabled if the required libraries are installed on the operating system.
> A noticeable exception is native compilation, as its a relatively new feature and not enabled by default.


## Building Emacs locally

Build Emacs using all the CPU's of your computer.  `-j` flag specifies the number of CPU's to use, `nproc` command returns the total number of CPU's for the computer (real and virtual cores combined).

```
make -j$(nproc)
```

Run Emacs using the `-Q` option to check Emacs runs without using a users configuration file (e.g. without loading an `~/.emacs.d/ configuration)

```
./src/emacs -Q
```

`C-x C-c` to quit Emacs.

If Emacs runs then it is ready to install.


## Install Emacs system wide

Install `emacs` and `emacsclient` to `/usr/local/bin` along with supporting libraries and man pages using the Makefile

```
sudo make install
```

To install in a different location, pass the full path using the `--prefix` option to make, e.g `make install --prefix /opt/emacs`


## Running Emacs

If the default `/usr/local` path was used to install Emacs, then the `emacs` and `emacsclient` binary files are already on the executable path

In a terminal, run the emacs command

```
emacs
```

If using Emacs 28 with Spacemacs for the first time, all Spacemacs packages in your configuration will be downloaded and compiled.  This may take 5-15 minutes and Emacs may make full use of your CPU (spawning several emacs processes on multi-core computers)

Leave Emacs for a few minutes running until the CPU activity has subsided and then consider restarting Emacs to ensure the packages have been loaded in the correct order.

> Expect to see lots of warning messages when installing more than 250 emacs packages.  Ignore these warnings until all packages have been installed.  If warnings still occur after restarting Emacs, then start investigating (or ask questions on #spacemacs channel in the Clojurians Slack community)


## Removing Emacs

In the Emacs source code directory where Emacs was built, use the Makefile to remove the Emacs binaries, libraries and man pages.

```
sudo make uninstall
```


## Emacs build configure output

Typical output of  `./configure --with-native-compilation`

Almost all configuration options should be yes, although there are a few legacy libraries or settings for other OSs that should be no.

```
Configured for 'x86_64-pc-linux-gnu'.

  Where should the build process find the source code?    .
  What compiler should emacs be built with?               /usr/bin/gcc-10 -g3 -O2
  Should Emacs use the GNU version of malloc?             no
    (The GNU allocators don't work with this system configuration.)
  Should Emacs use a relocating allocator for buffers?    no   (use operating system allocator)
  Should Emacs use mmap(2) for buffer allocation?         no  (use operating system mmap)
  What window system should Emacs use?                    x11
  What toolkit should Emacs use?                          GTK3
  Where do we find X Windows header files?                Standard dirs
  Where do we find X Windows libraries?                   Standard dirs
  Does Emacs use -lXaw3d?                                 no  (superseded by gtk)
  Does Emacs use -lXpm?                                   yes
  Does Emacs use -ljpeg?                                  yes
  Does Emacs use -ltiff?                                  yes
  Does Emacs use a gif library?                           yes -lgif
  Does Emacs use a png library?                           yes -lpng16 -lz
  Does Emacs use -lrsvg-2?                                yes
  Does Emacs use cairo?                                   yes
  Does Emacs use -llcms2?                                 yes
  Does Emacs use imagemagick?                             no  (deprecated Emacs 27.1 - security issues)
  Does Emacs use native APIs for images?                  no  (only for MS-Windows)
  Does Emacs support sound?                               yes
  Does Emacs use -lgpm?                                   yes
  Does Emacs use -ldbus?                                  yes
  Does Emacs use -lgconf?                                 no
  Does Emacs use GSettings?                               yes
  Does Emacs use a file notification library?             yes -lglibc (inotify)
  Does Emacs use access control lists?                    yes -lacl
  Does Emacs use -lselinux?                               yes
  Does Emacs use -lgnutls?                                yes
  Does Emacs use -lxml2?                                  yes
  Does Emacs use -lfreetype?                              yes
  Does Emacs use HarfBuzz?                                yes
  Does Emacs use -lm17n-flt?                              yes
  Does Emacs use -lotf?                                   yes
  Does Emacs use -lxft?                                   no
  Does Emacs use -lsystemd?                               yes
  Does Emacs use -ljansson?                               yes
  Does Emacs use the GMP library?                         yes
  Does Emacs directly use zlib?                           yes
  Does Emacs have dynamic modules support?                yes
  Does Emacs use toolkit scroll bars?                     yes
  Does Emacs support Xwidgets?                            no  (deprecated)
  Does Emacs have threading support in lisp?              yes
  Does Emacs support the portable dumper?                 yes
  Does Emacs support legacy unexec dumping?               no
  Which dumping strategy does Emacs use?                  pdumper
  Does Emacs have native lisp compiler?                   yes
```


## References

* [Emacs 28.1 whats new](https://www.masteringemacs.org/article/whats-new-in-emacs-28-1) - a very detailed description of new features in Emacs 28.1
* [Emacs Wiki - Building Emacs](https://www.emacswiki.org/emacs/BuildingEmacs) - base instructions for building Emacs
* [Ubuntu Emacs LISP team PPA](https://launchpad.net/~ubuntu-elisp/+archive/ubuntu/ppa) - nightly builds from the latest Emacs commits


---
Thank you.

[:fontawesome-brands-github: practicalli-johnny](https://github.com/practicalli-johnny){target=_blank .md-button}
