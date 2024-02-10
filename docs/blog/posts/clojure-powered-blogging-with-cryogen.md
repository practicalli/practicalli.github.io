---
title: "Clojure powered blogging with Cryogen"
date: 2019-10-20
authors:
  - practicalli
categories:
  - cryogen
tags:
  - cryogen
  - blogging
  - static-site
---

![Practicalli Clojure Logo](https://github.com/practicalli/graphic-design/blob/live/topic-images/cryogen-logo-name.png?raw=true){align=right loading=lazy style="width:240px"}

A blog website shouldnt need a complex content management system. A simple and lightweight static website generator can create engaging websites that are simple to manage with Git.

Cryogen is a static site generator written in Clojure, allowing content to be written in either markdown or asciidoc.  Posts and pages are configured with Clojure hash-maps to manage the meta-data and layout information for each post.

Cryogen seems very quick to generate a site and a local server can be run to automatically generate an updated website when changes to posts and pages are saved.

<!-- more -->

[:fontawesome-brands-github: practicalli/blog-cryogen](https://github.com/practicalli/blog-cryogen/){target=_blank} contains all the content and configuration used to create the Practicalli blog website.

!!! WARNING "Markdown tables not supported"
    **Limitation/bug** cryogen does not support tables in markdown posts.  

    The issue seem to reside in [:fontawesome-brands-github: cryogen-markdown library](https://github.com/cryogen-project/cryogen-markdown){target=_blank}


## Requirements

Clojure CLI and clj-new template to create and manage a Cryogen project

A Java virtual Machine is a dependency for Clojure CLI, eg. [Temurin from Adoptium.net](https://adoptium.net/)

[:fontawesome-solid-book-open: Install Clojure - Practicalli Clojure book](https://practical.li/clojure/install/)(target=_blank .md-button)

## Create a new site

Use the `cryogen` template for Leiningen to create a new project

Here we create a project called `practicalli-blog` using the template

!!! NOTE "Create a Cryogen project"
    ```
    clojure -T:project/new :template cryogen :name practicalli/blog
    ```

Change into the project directory and use Leiningen to run the project

!!! NOTE "Start Cryogen local server"
    ```
    clojure -X:serve
    ```

A server will now start and generate the sample posts provided by the Cryogen template.

The web browser automatically open a new browser tab/window at `http://localhost:3000/blog`

> Changing files in the project will trigger a new compilation of the website. Manually refresh the browser page if kept open.


## Configure the site

The configuration defines the site title (banner heading), author (copyright message), description (not sure where this is used).

`content/config.edn` is the configuration file for the generated site

!!! EXAMPLE "Practicalli Blog Cryogen config"
```config
 :site-title           "Practicalli"
 :author               "Practicalli"
 :description          "Discovering the fun in Functional Programming with Clojure"
 :site-url             "http://practical.li/"
```


### Enable live evaluation with Klipse

Make your sample code executable and interactive to the user by enabling Klipse in Cryogen. Klipse provides live evaluation for a number of programming language.

Enable Klipse by defining a specific CSS selector and use that name when defining a code block, e.g. ```klipse-clj```

!!! EXAMPLE "Cryogen Klipse config"
    ```config
     :klipse               {:settings {:selector         ".klipse-clj"
                                       :selector-reagent ".klipse-reagent"}}
    ```

> Example [config.edn file](https://github.com/practicalli/blog-content/blob/master/content/config.edn) from the practicalli/blog-content GitHub repository


## Version control

A `.gitignore` file is created when using the cryogen template to create a project.

This contains the `/public/` pattern to exclude the generated website, as well as the common patterns for a Leiningen project.


## Writing posts

Posts can be written in either markdown or asciidoc.  Markdown is the default and all posts should be placed inthe `content/md/` directory.

The filename can be prefixed with the date of the post, however, I find it more flexible to specify the date in the post metadata header as if you change the date then the URL of the post will remain the same.  This is really handy if you need to update the post and need to reflect that in the date, or if you had planned to publish the post a few weeks in the future and then realise its ready sooner.

### Post header - metadata

The start of each post is a Clojure hash-map, `{}` containing metadata for the specific blog

`:title` and `:layout` are mandatory keys, the rest are optional.  You can also define your own custom keys which can be used in the selma templates, for example `:topic`

* `:title`   The `h1` title used for the blog post
* `:layout`  A keyword corresponding to an HTML file under themes/{theme}/html.
* `:date`    The published date of the blog  (future blogs can be hidden)
* `:author`  The name of the post author as a string, displayed at the top of the post in the default theme.
* `:tags`    Tags associated with the blog, as a vector of strings e.g. ["clojure" "cryogen"]
* `:klipse`  Enable live evaluation of code in the post (see live evaluation with Klipse)
* `:toc`     Include a table of contents at the top of the page, with links to all the headings in the post
* `:draft?`  `true` will skip this post from the static site generation
* `:topic`   A custom key I use to manage a topic image displayed on each post (theme development will be covered in a future post)


## Deploying the site to GitHub pages

!!! INFO "Automate publish with GitHub workflow"
    [Automate Cryogent blog publishing ](automate-cryogen-clojure-blog-with-github-actions){target=_blank} describes how to build and deploy a Cryogen blog with a GitHub CI workflow.

GitHub pages is a free static site hosting service and we can deploy the cryogen website by a git push.

Create a repository in either a user account or GitHub organisation (eg. using the GitHub website).

An unsophisticated script is used to deploy the generated website.  The script creates a Git repository in the `public` directory, all files are committed with a generic message, a remote repository added and the content pushed.

!!! NOTE ""
    ```shell
    cd public/blog && \
    rm -rf .git && git init && git add . && \
    git commit -m "publish blog" && \
    git branch -m master gh-pages && \ 
    git remote add practicalli git@github.com:practicalli/blog.git && \
    git push -f practicalli gh-pages
    ```

Edit the `deploy-to-gh-pages` script and update the URL of the GitHub repository created to host the website.

If the website is not displayed, check the GitHub repository settings and ensure the `gh-pages` is set.

!!! HINT "Serve GitHub Pages from docs directory"
    Set the `docs` directory as the source of GitHub pages source for the, especially when supporting a software project or library.

### Prevent GitHub pages Jekyll compilation

A Jekyll process runs every time a change is pushed to a GitHub pages branch.  As Cryogen generates the finished website Jekyll processing is not required and it can be switch it off.

Add an empty file called `.nojekyll` to the `content` directory.

Edit the `config.edn` configuration file and add the `.nojekyll` file to the resources.  This ensures the `.nojekyll` file is copied over to the generated website in the `public` directory.

!!! EXAMPLE "Disable Jekyll"
    ```config
     :resources            ["images" ".nojekyll"]
    ```

---
Thank you.

[:globe_with_meridians: Practical.li Website](https://practical.li){target=_blank .md-button} 

[:fontawesome-brands-github: Practical.li GitHub Org](https://github.com/practicalli){target=_blank .md-button} 
[:fontawesome-brands-github: practicalli-johnny profile](https://github.com/practicalli-johnny){target=_blank .md-button}

[:fontawesome-brands-mastodon: @practicalli@clj.social](https://clj.social/@practicalli){target=_blank .md-button}
[:fontawesome-brands-twitter: @practical_li](https://twitter.com/practcial_li){target=_blank .md-button}
