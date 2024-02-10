---
draft: false 
title: "Build Emacs from source on Debian Linux"
date: 2023-10-21
authors:
  - practicalli
categories:
  - emacs
tags:
  - debian
  - spacemacs
  - emacs
---

![Practicalli Emacs Logo](https://github.com/practicalli/graphic-design/blob/live/topic-images/emacs-logo-name.png?raw=true){align=right loading=lazy style="width:240px"}

Emacs 29 is the current stable release, adding major features: Eglot LSP client, Tree-Sitter language parser and `package.el` package install from Git repositories. 

Building from source is a convenient way to try Emacs features in advance, especially useful for those maintaining or developing new tools on top of Emacs.

??? INFO "Emacs 29 Features"
    [Emacs 29 - what to expect](https://blog.phundrak.com/emacs-29-what-can-we-expect/) - a brief summary of the major features

<!-- more -->

## Building steps for the impatient

Open a terminal and switch to the adminstrator account

```shell
su -
```

Add debian packages to support building Emacs

```shell
apt build-dep emacs && \
apt install libgccjit0 libgccjit-10-dev libjansson4 libjansson-dev gnutls-bin libtree-sitter-dev
```

[Clone Emacs 29 source code](https://git.savannah.gnu.org/cgit/emacs.git), configure and build emacs and then install (in /usr/local/bin/)

```shell
git clone --branch emacs-29 git://git.savannah.gnu.org/emacs.git emacs-29 && \
cd emacs-29 && \
export CC=/usr/bin/gcc-10 && \
export CXX=/usr/bin/gcc-10 && \ 
./autogen.sh && \
./configure --with-native-compilation=aot && \
make -j$(proc)  && \
make install
```

> Skip the `--branch` argument for the very latest commits to Emacs which will effectively become Emacs 30 some time in the next year or so

Read the rest of the article for a detailed description of this workflow


## Prepare Debian

Open a terminal and switch to the adminstrator account

```shell
su -
```

Use the Debian package manager to install the build dependencies for the Emacs package. 

Debian installs the packages required to build Emacs, there will be many package to install if this is the first software is being built with GCC on the operating system.

```shell
apt build-dep -y emacs
```

> Using build-deps manages the set of packages required as Emacs evolves.

Install library packages to support the newest features of Emacs, e.g. native compilation of Emacs packages (`libgccjit`), fast JSON processing (`libjansson`) and tree-sitter support.  These features can significantly boost performance.

```shell
sudo apt install libgccjit0 libgccjit-10-dev libjansson4 libjansson-dev libtree-sitter-dev
```

> `sudo apt-get install gnutls-bin` removes a potential issue from an older certificates library install


## Preparing Emacs source code

Use a Git client to clone the latest code from [the Emacs repository](https://git.savannah.gnu.org/cgit/emacs.git), or open a terminal and use the Git command line client

```shell
git clone git://git.savannah.gnu.org/emacs.git
```

> To build version of Emacs that is already release, **[Download source from a nearby GNU mirror](https://www.gnu.org/software/emacs/download.html)**, either tar.gz or tar.xz

Change into the cloned directory

```shell
cd emacs
```

Set `CC` and `CXX` environment variables to inform the Emacs configuration script as to the location of gcc-10, otherwise it fails to find libgccjit

```shell
export CC=/usr/bin/gcc-10 && export CXX=/usr/bin/gcc-10
```

> If CC and CXX environment variables are not set, the configure script will not find important libraries and report errors such as: `configure: error: ELisp native compiler was requested, but libgccjit was not found.`


Run the autogen script to create a configure script specific to your operating system.

```shell
./autogen.sh
```

Run the configuration script with the native compilation flag, to compile Emacs native Elisp files during the Emacs compilation rather than when first running Emacs.  This script will check the operating system for tools and libraries needed to build Emacs on your operating system.

```shell
./configure --with-native-compilation=aot
```

Check the output of `./configure` was successful, see the end of this article for an example.  Ignore warnings about movemail if not using Emacs for local email management.

??? HINT "List available Emacs build flags"
    `./configure --help` lists available flags. Generally features are enabled if the required libraries are installed on the operating system.

    A noticeable exception is native compilation, as its a relatively new feature and not enabled by default.


## Building Emacs locally

Build Emacs using all the CPU's of your computer.  `-j` flag specifies the number of CPU's to use, `nproc` command returns the total number of CPU's for the computer (real and virtual cores combined).

```shell
make -j$(nproc)
```

Run Emacs using the `-Q` option to check Emacs runs without using a users configuration file (e.g. without loading an `~/.emacs.d/ configuration)

```shell
./src/emacs -Q
```

`C-x C-c` to quit Emacs.

If Emacs runs then it is ready to install.


## Install Emacs system wide

Install `emacs` and `emacsclient` to `/usr/local/bin` along with supporting libraries and man pages using the Makefile

```shell
make install
```

To install in a different location, pass the full path using the `--prefix` option to make, e.g `make install --prefix /opt/emacs`


## Running Emacs

If the default `/usr/local` path was used to install Emacs, then the `emacs` and `emacsclient` binary files are already on the executable path

In a terminal, run the emacs command

```shell
emacs
```

??? HINT "Spacemacs installs packages for a version of Emacs"
    Using a different version of Emacs with Spacemacs for the first time will download and compile all the pages in the Spacemacs configuration.  

When native compliation is enabled, many minutes are required to navitvely compile each and every Emacs package.

Leave Emacs for a few minutes running until the CPU activity has subsided and then consider restarting Emacs to ensure the packages have been loaded in the correct order.

> Expect to see lots of warning messages when installing more than 250 emacs packages.  Ignore these warnings until all packages have been installed.  If warnings still occur after restarting Emacs, then start investigating (or ask questions on #spacemacs channel in the Clojurians Slack community)


## Removing Emacs

In the Emacs source code directory where Emacs was built, use the Makefile to remove the Emacs binaries, libraries and man pages.

```shell
make uninstall
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
  Should Emacs use a relocating allocator for buffers?    no
  Should Emacs use mmap(2) for buffer allocation?         no
  What window system should Emacs use?                    x11
  What toolkit should Emacs use?                          GTK3
  Where do we find X Windows header files?                Standard dirs
  Where do we find X Windows libraries?                   Standard dirs
  Does Emacs use -lXaw3d?                                 no
  Does Emacs use -lXpm?                                   yes
  Does Emacs use -ljpeg?                                  yes
  Does Emacs use -ltiff?                                  yes
  Does Emacs use a gif library?                           yes -lgif
  Does Emacs use a png library?                           yes -lpng16 -lz
  Does Emacs use -lrsvg-2?                                yes
  Does Emacs use -lwebp?                                  no
  Does Emacs use -lsqlite3?                               yes
  Does Emacs use cairo?                                   yes
  Does Emacs use -llcms2?                                 yes
  Does Emacs use imagemagick?                             no
  Does Emacs use native APIs for images?                  no
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
  Does Emacs use -ltree-sitter?                           yes
  Does Emacs use the GMP library?                         yes
  Does Emacs directly use zlib?                           yes
  Does Emacs have dynamic modules support?                yes
  Does Emacs use toolkit scroll bars?                     yes
  Does Emacs support Xwidgets?                            no
  Does Emacs have threading support in lisp?              yes
  Does Emacs support the portable dumper?                 yes
  Does Emacs support legacy unexec dumping?               no
  Which dumping strategy does Emacs use?                  pdumper
  Does Emacs have native lisp compiler?                   yes
  Does Emacs use version 2 of the X Input Extension?      yes
  Does Emacs generate a smaller-size Japanese dictionary? no
```

## Emacs 29 configuration options

Run configure with `--help` option to list the available compilation options.  Apart from `--with-native-compilation=aot` defaults are used when Practicalli compiles Emacs.

```shell
Optional Packages:
  --with-PACKAGE[=ARG]    use PACKAGE [ARG=yes]
  --without-PACKAGE       do not use PACKAGE (same as --with-PACKAGE=no)
  --without-all           omit almost all features and build small executable
                          with minimal dependencies
  --with-mailutils        rely on GNU Mailutils, so that the --without-pop
                          through --with-mailhost options are irrelevant; this
                          is the default if GNU Mailutils is installed
  --with-pop              Support POP mail retrieval if Emacs movemail is used
                          (not recommended, as Emacs movemail POP is
                          insecure). This is the default only on native
                          MS-Windows.
  --with-kerberos         support Kerberos-authenticated POP
  --with-kerberos5        support Kerberos version 5 authenticated POP
  --with-hesiod           support Hesiod to get the POP server host
  --with-mail-unlink      unlink, rather than empty, mail spool after reading
  --with-mailhost=HOSTNAME
                          string giving default POP mail host
  --with-sound=VALUE      compile with sound support (VALUE one of: yes, alsa,
                          oss, bsd-ossaudio, no; default yes). Only for
                          GNU/Linux, FreeBSD, NetBSD, MinGW, Cygwin.
  --with-pdumper=VALUE    enable pdumper support unconditionally ('yes', 'no',
                          or 'auto': default 'auto')
  --with-unexec=VALUE     enable unexec support unconditionally ('yes', 'no',
                          or 'auto': default 'auto')
  --with-dumping=VALUE    kind of dumping to use for initial Emacs build
                          (VALUE one of: pdumper, unexec, none; default
                          pdumper)
  --with-x-toolkit=KIT    use an X toolkit (KIT one of: yes or gtk, gtk2,
                          gtk3, lucid or athena, motif, no)
  --with-wide-int         prefer wide Emacs integers (typically 62-bit); on
                          32-bit hosts, this allows buffer and string size up
                          to 2GB, at the cost of 10% to 30% slowdown of Lisp
                          interpreter and larger memory footprint
  --without-xpm           don't compile with XPM image support
  --without-jpeg          don't compile with JPEG image support
  --without-tiff          don't compile with TIFF image support
  --without-gif           don't compile with GIF image support
  --without-png           don't compile with PNG image support
  --without-rsvg          don't compile with SVG image support
  --without-webp          don't compile with WebP image support
  --without-sqlite3       don't compile with sqlite3 support
  --without-lcms2         don't compile with Little CMS support
  --without-libsystemd    don't compile with libsystemd support
  --without-cairo         don't compile with Cairo drawing
  --without-xml2          don't compile with XML parsing support
  --with-imagemagick      compile with ImageMagick image support
  --without-native-image-api
                          don't use native image APIs (GDI+ on Windows)
  --with-json             compile with native JSON support
  --with-tree-sitter      compile with tree-sitter
  --without-xft           don't use XFT for anti aliased fonts
  --without-harfbuzz      don't use HarfBuzz for text shaping
  --without-libotf        don't use libotf for OpenType font support
  --without-m17n-flt      don't use m17n-flt for text shaping
  --without-toolkit-scroll-bars
                          don't use Motif/Xaw3d/GTK toolkit scroll bars
  --without-xaw3d         don't use Xaw3d
  --without-xim           at runtime, default X11 XIM to off
  --without-xdbe          don't use X11 double buffering support
  --with-ns               use Nextstep (macOS Cocoa or GNUstep) windowing
                          system. On by default on macOS.
  --with-w32              use native MS Windows GUI in a Cygwin build
  --with-pgtk             use GTK to support window systems other than X
  --without-gpm           don't use -lgpm for mouse support on a GNU/Linux
                          console
  --without-dbus          don't compile with D-Bus support
  --with-gconf            compile with Gconf support (Gsettings replaces this)
  --without-gsettings     don't compile with GSettings support
  --without-selinux       don't compile with SELinux support
  --without-gnutls        don't use -lgnutls for SSL/TLS support
  --without-zlib          don't compile with zlib decompression support
  --without-modules       don't compile with dynamic modules support
  --without-threads       don't compile with elisp threading support
  --with-cygwin32-native-compilation
                          use native compilation on 32-bit Cygwin
  --without-xinput2       don't use version 2 of the X Input Extension for
                          input
  --with-small-ja-dic     generate a smaller-size Japanese dictionary
  --with-file-notification=LIB
                          use a file notification library (LIB one of: yes,
                          inotify, kqueue, gfile, w32, no)
  --with-xwidgets         enable use of xwidgets in Emacs buffers (requires
                          gtk3 or macOS Cocoa)
  --with-be-app           enable use of Haiku's Application Kit as a window
                          system
  --with-be-cairo         enable use of cairo under Haiku's Application Kit
  --without-compress-install
                          don't compress some files (.el, .info, etc.) when
                          installing. Equivalent to: make GZIP_PROG= install
  --with-gameuser=USER_OR_GROUP
                          user for shared game score files. An argument
                          prefixed by ':' specifies a group instead.
  --with-gnustep-conf=FILENAME
                          name of GNUstep configuration file to use on systems
                          where the command 'gnustep-config' does not work;
                          default $GNUSTEP_CONFIG_FILE, or
                          /etc/GNUstep/GNUstep.conf
  --with-native-compilation[=TYPE]
                          compile with Emacs Lisp native compiler support. The
                          TYPE 'yes' (or empty) means to enable it and compile
                          natively preloaded Lisp files; 'no' means to disable
                          it; 'aot' will make the build process compile all
                          the Lisp files in the tree natively ahead of time.
                          (This will usually be quite slow.)
  --with-x                use the X Window System
  --without-libgmp        do not use the GNU Multiple Precision (GMP) library;
                          this is the default on systems lacking libgmp.
  --without-included-regex
                          don't compile regex; this is the default on systems
                          with recent-enough versions of the GNU C Library
                          (use with caution on other systems).
```

## References

* [Emacs 28.1 whats new](https://www.masteringemacs.org/article/whats-new-in-emacs-28-1) - a very detailed description of new features in Emacs 28.1
* [Emacs Wiki - Building Emacs](https://www.emacswiki.org/emacs/BuildingEmacs) - base instructions for building Emacs
* [Ubuntu Emacs LISP team PPA](https://launchpad.net/~ubuntu-elisp/+archive/ubuntu/ppa) - nightly builds from the latest Emacs commits

---
Thank you.

[:globe_with_meridians: Practical.li Website](https://practical.li){target=_blank .md-button} 

[:fontawesome-brands-github: Practical.li GitHub Org](https://github.com/practicalli){target=_blank .md-button} 
[:fontawesome-brands-github: practicalli-johnny profile](https://github.com/practicalli-johnny){target=_blank .md-button}

[:fontawesome-brands-mastodon: @practicalli@clj.social](https://clj.social/@practicalli){target=_blank .md-button}
[:fontawesome-brands-twitter: @practical_li](https://twitter.com/practcial_li){target=_blank .md-button}
