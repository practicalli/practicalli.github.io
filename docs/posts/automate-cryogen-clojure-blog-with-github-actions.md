---
draft: false 
title: "Automate Cryogen Clojure blog with GitHub Actions"
date: 2021-08-28
authors:
  - practicalli
categories:
  - cryogen
tags:
  - static-site
  - github-action
---

![Practicalli Clojure Logo](https://github.com/practicalli/graphic-design/blob/live/topic-images/cryogen-logo-name.png?raw=true){align=right loading=lazy style="width:240px"}

[Practicalli uses Cryogen static site generator for its blog website](https://practical.li/blog/posts/clojure-powered-blogging-with-cryogen/).  Cryogen is fast and simple to use thanks to the Clojure EDN file used for configuration.

Cryogen documentation shows [how to publish a Cryogen blog to GitHub pages](https://cryogenweb.org/docs/deploying-to-github-pages.html) using Git command.  The deployment can be automated using GitHub actions, so that a new version of the site is deployed when Pull Requests are merged to the specified branch (or on direct commits to that branch).

<!-- more -->

## What does the GitHub workflow do?

This is a combination of GitHub actions, each doing a specific part of the automated workflow.

The **publish** job runs on an Ubuntu docker image and the **Checkout** step performs a git checkout of the project into the docker image.

**Prepare Java** step uses the [setup-java action](https://github.com/actions/setup-java) to add Java 11 to the docker image, using the Eclipse Foundation `temurin` image ([OpenJDK / AdoptOpenJDK is now part of the Eclipse Foundation](https://blog.adoptopenjdk.net/2021/08/goodbye-adoptopenjdk-hello-adoptium/)).

**Install clojure tools** step uses the [setup-clojure action](https://github.com/DeLaGuardo/setup-clojure) to add the specified version of Clojure CLI tools (Leiningen and Boot build tools are also supported)

**Build blog site** step calls the Cryogen function using Clojure CLI tools to build the static site

**Publish to GitHub pages** step uses the [github-pages-deploy-action](https://github.com/JamesIves/github-pages-deploy-action) to deploy a specific directory, the directory built by Cryogen, to another branch of the original repository or a different repository. If the branch does not exist, the action will create it.


## Deploying to other repositories

When deploying the Cryogen site to the same GitHub repository as the source files, the [github-pages-deploy-action](https://github.com/JamesIves/github-pages-deploy-action) does not require an explicit token to be added. The action uses the default repository scoped GitHub token.

If deploying the site to another repository from that of its source files, create a GitHub secret with a value of a Personal Access Token (PAT). The personal access token should have the least permissions necessary, usually only `repo`.

A GitHub secret can be added at user or organisation level and configured for specific repositories.


## Add GitHub Action

Create a file called `.github/workflows/cryogen-publish.yml` and add a workflow configuration.

```json
name: Publish Blog
on:
  push:
    branches:
    - live

jobs:
  publish:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2

      - name: Prepare java
        uses: actions/setup-java@v2
        with:
          distribution: 'temurin'
          java-version: '11'

      - name: Install clojure tools
        uses: DeLaGuardo/setup-clojure@3.5
        with:
          cli: 1.10.3.943

      - name: Build Blog site
        run: clojure -M:build

      - name: Publish to GitHub Pages
        uses: JamesIves/github-pages-deploy-action@4.1.4
        with:
          commit-message: ${{ github.event.head_commit.message }}
          branch: gh-pages                                      # branch to deploy to
          single-commit: yes                                    # no commit history
          folder: public/blog                                   # directory to deploy from
```


## GitHub Action configuration with token

If deploying to a different repository than the source, then add a token to either a [repository, account or organisation secret](https://docs.github.com/en/actions/reference/encrypted-secrets).  Use a [GitHub Personal Access Token](https://docs.github.com/en/github/authenticating-to-github/keeping-your-account-and-data-secure/creating-a-personal-access-token) for the value of the token secret.


```json
      - name: Publish to GitHub Pages
        uses: JamesIves/github-pages-deploy-action@4.1.4
        with:
          commit-message: ${{ github.event.head_commit.message }}
          token: ${{ secrets.PRACTICALLI_BLOG_PUBLISH_TOKEN }}  # GitHub secret
          repository-name: practicalli/deployed-blog            # repository to deploy to
          branch: gh-pages                                      # branch to deploy to
          single-commit: yes                                    # no commit history
          folder: public/blog                                   # directory to deploy from
```


## Deploying to AWS S3 bucket

Cryogen can also be published to an Amazon S3 bucket by taking the above GitHub action and replacing the **Publish to GitHub Pages** step.

Add the following step in its place and add GitHub secrets to the Git Repository for AWS access and the name of the AWS bucket.

```json
    - name: Publish to AWS S3
      uses: jakejarvis/s3-sync-action@master
      with:
        args: --follow-symlinks --delete --acl public-read
      env:
        AWS_S3_BUCKET: ${{ secrets.AWS_S3_BUCKET }}
        AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
        AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        AWS_REGION: 'eu-west-2'
        SOURCE_DIR: 'public/blog'
```

> NOTE: also check the AWS region is the correct one for your needs


## Summary

Once the `.github/workflows/cryogent-publish.yml` file is committed to the default branch of the repository, any commits to that branch or merged pull requests to that branch will trigger the workflow and publish a new version of the Cryogen static website.

Consider adding linters and other GitHub Actions to check for potential issues with markdown and other aspects of the website, to avoid checking in content that may break the website.

Setting up monitoring of the website is also recommended, using simple monitoring tools such as [StatusCake](https://www.statuscake.com/).

---
Thank you.

[:globe_with_meridians: Practical.li Website](https://practical.li){target=_blank .md-button} 

[:fontawesome-brands-github: Practical.li GitHub Org](https://github.com/practicalli){target=_blank .md-button} 
[:fontawesome-brands-github: practicalli-johnny profile](https://github.com/practicalli-johnny){target=_blank .md-button}

[:fontawesome-brands-mastodon: @practicalli@clj.social](https://clj.social/@practicalli){target=_blank .md-button}
[:fontawesome-brands-twitter: @practical_li](https://twitter.com/practcial_li){target=_blank .md-button}
