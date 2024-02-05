---
title: "Docker: a simple workflow for Clojure"
date: 2023-05-15
authors:
  - practicalli
categories:
  - docker
tags:
  - docker
---

![Practicalli Clojure Logo](https://github.com/practicalli/graphic-design/blob/live/topic-images/docker-logo-name.png?raw=true){align=right loading=lazy style="width:240px"}

Docker enables a consistent approach to building and running Clojure projects along with a range of other services locally (database, cache, streams, etc.), The Clojure project is built from source when starting services (a `watch` feature can rebuild on code changes). Heath checks and conditions are set to ensure dependant services start in the correct order.

Running Docker is relatively fast once image overlays (layers) are cached on their first run, so its a viable approach for local system integration testing and acceptance testing, before pushing changes to a remote Continuous Integration service.

A Docker workflow complements a [:fontawesome-solid-book-open: REPL Driven Development workflow](https://practical.li/clojure/introduction/repl-workflow/){target=_blank}, it does not replace it.  The main development effort should be more effective via a REPL connected editor with Docker Compose focused on orchestration of services.

!!! HINT "Deeper into Docker"
    [:fontawesome-solid-book-open: Practicalli Engineering Playbook](https://practical.li/engineering-playbook/continuous-integration/docker/clojure-multi-stage-dockerfile/){target=_blank} covers Docker and Compose in more detail

<!-- more -->

## General Workflow

- Create a Clojure project, e.g. using [:fontawesome-solid-book-open: Practicalli Project Templates](https://practical.li/clojure/clojure-cli/projects/templates/){target=_blank}
- Install Docker Desktop & Extensions, e.g. [:fontawesome-solid-book-open: Docker Desktop for Ubuntu](https://practical.li/blog/posts/docker-desktop-on-ubuntu-linux/){target=_blank}
- Create a Dockerfile e.g. [:fontawesome-solid-book-open: multi-stage build and run-time configuration for Clojure](https://practical.li/engineering-playbook/continuous-integration/docker/clojure-multi-stage-dockerfile/){target=_blank}
- [:fontawesome-solid-book-open: Compose services](https://practical.li/engineering-playbook/continuous-integration/docker/compose/) together, adding health checks and conditional starts
- REPL driven development, e.g. [:fontawesome-solid-book-open: Practicalli REPL Reloaded Workflow](https://practical.li/clojure/clojure-cli/repl-reloaded/){target=_blank}
- (optional) Automatic rebuild of Clojure project when [:fontawesome-solid-book-open: watching for code changes](https://practical.li/engineering-playbook/continuous-integration/docker/compose/#file-watcher){target=_blank} (experimental feature)


!!! HINT "Docker getting started tutorial"
    Follow the Docker getting started tutorial once Docker is installed

    ```shell
    docker run -d -p 80:80 docker/getting-started
    ```

## Docker Desktop

[:globe_with_meridians: Docker desktop](https://docs.docker.com/desktop/){target=_blank} provides a convienient way to manage Docker images, containers and volumes.  Sign in to Docker Desktop to manage your images on DockerHub.

![Docker Desktop - images view](https://github.com/practicalli/graphic-design/blob/live/continuous-integration/docker-desktop-images-light.png?raw=true)

There is a growing marketplace of extensions that provide very useful tools to extend the capabilities of Docker Desktop.  Search within the Docker Desktop extensions or for [:globe_with_meridians: extensions on Docker Hub](https://hub.docker.com/search?q=&type=extension){target=_blank}.

- [:globe_with_meridians: Resource Usage](https://hub.docker.com/extensions/docker/resource-usage-extension){target=_blank} monitor resources (cpu, memory, network, disk) used by containers and docker compose systems over time
- [:globe_with_meridians: Disk Usage](https://hub.docker.com/extensions/docker/disk-usage-extension){target=_blank} optimise use of local disk space by removing unused images, containers and volumes
- [:globe_with_meridians: Volumes Backup & Share](https://hub.docker.com/extensions/docker/volumes-backup-extension){target=_blank} to backup, clone, restore and share Docker volumes easily
- [:globe_with_meridians: Logs Explorer](https://hub.docker.com/extensions/docker/logs-explorer-extension){target=_blank} view all container logs in one place to assist troubleshooting
- [:globe_with_meridians: Postgres Admin](https://hub.docker.com/extensions/mochoa/pgadmin4-docker-extension){target=_blank} PGAdmin4 open source management tool for Postgres
- [:globe_with_meridians: Trivy](https://hub.docker.com/extensions/aquasec/trivy-docker-extension){target=_blank} scan local and remote images for security vulnerabilities
- [:globe_with_meridians: Snyk](https://hub.docker.com/extensions/snyk/snyk-docker-desktop-extension){target=_blank} scan local and remote images for security vulnerabilities
- [:globe_with_meridians: Ddosify](https://hub.docker.com/extensions/ddosify/ddosify-docker-extension){target=_blank} high-performance, open-source and simple load testing tool

![Docker Desktop extension - disk usage](https://github.com/practicalli/graphic-design/blob/live/continuous-integration/docker-desktop-extensions-disk-usage-light.png?raw=true)

## Choosing Docker Images

[:globe_with_meridians: Docker Official Images](https://docs.docker.com/docker-hub/official_images/){target=_blank} from Docker Hub are highly recommended.  Look for the Docker Official Image tag on the image page.

![Docker Official Image Tag](https://docs.docker.com/trusted-content/images/official-image-badge-iso.png)

- [:globe_with_meridians: Clojure - official Docker Image](https://hub.docker.com/_/clojure/){target=_blank} - built by the Clojure community, provides tools to build Clojure projects (Clojure CLI, Leiningen)
- [:globe_with_meridians: Eclipse temurin OpenJDK - official Docker image](https://hub.docker.com/_/eclipse-temurin){target=_blank} - built by the [:globe_with_meridians: community](https://adoptium.net/){target=_blank} - provides the Java run-time
- [:globe_with_meridians: Amazon Corretto](https://hub.docker.com/_/amazoncorretto){target=_blank} is an OpenJDK distribution by Amazon AWS team, [:globe_with_meridians: Amazon Corretto](https://aws.amazon.com/corretto/) can also be installed for the local development environment
- [:globe_with_meridians: Postgres](https://hub.docker.com/_/postgres){target=_blank} open-source object-relational database management system
- [:globe_with_meridians: Redis](https://hub.docker.com/_/redis){target=_blank} open-source, networked, in-memory, key-value data store with optional durability
- [:globe_with_meridians: nginx](https://hub.docker.com/_/nginx){target=_blank} open source reverse proxy & load balancing for HTTP, HTTPS, SMTP, POP3 & IMAP protocols, HTTP cache and a web server
- [:globe_with_meridians: mariadb](https://hub.docker.com/_/mariadb){target=_blank} open source relational database by the original developers of MySQL and is much more efficient

!!! INFO "Official Docker Image definition"
    An Official Docker Image means the configuration of that image follows the [:globe_with_meridians: Docker recommended practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/){target=_blank}, is well documented and designed for common use cases.  

    There is no implication at to the correctness of tools, languages or service that image provides, only in the means in which they are provided.

## Use Multi-stage Dockerfile

A multi-stage `Dockerfile` contains `builder` stage and a `final` stage used as the run-time.  Optionally, the configuration can use a `base` stage that defines a common image and configuration which both build and final stages extend.

The builder stage caches dependencies to optimise building Clojure and the run-time stage optimises running the service efficiently and securely.

The uberjar created by the builder image is copied over to the final stage to keep the run-time image as clean and small as possible to minimise resource use.

![Docker Multi-stage build file with cached overlays](https://github.com/practicalli/graphic-design/blob/live/continuous-integration/docker-compose-build-output-cached-layers.png?raw=true)

[:fontawesome-solid-book-open: Multi-stage `Dockerfile` for Clojure projects](https://practical.li/engineering-playbook/continuous-integration/docker/clojure-multi-stage-dockerfile/){target=_blank .md-button}
- [:globe_with_meridians: Docker Multi-stage builds docs](https://docs.docker.com/build/building/multi-stage/){target=_blank .md-button}

!!! HINT "Docker init feature"
    [:globe_with_meridians: `docker init`](https://docs.docker.com/engine/reference/commandline/init/){target=_blank} is a new (beta) feature to create `Dockerfile`, `.dockerignore` and`compose.yaml` files using Docker recommended practices.

## Compose services

Define a `compose.yaml` file that builds the Clojure project and run services that the Clojure service requires or talks too (database, cache, mock API, etc.). Each service can define a heart beat that can be used as a conditional startup for other services.

!!! INFO "compose.yaml new configuration file"
    `compose.yaml` is the new configuration file for orchestrating services locally, a simplified and extended version of `docker-compose.yaml`.

Include the `build:` option for the Clojure service with the path to the multi-stage Dockerfile for the project (typically in the same root directory of the project, although a remote Git repository can also be used)

The Clojure service defines a dependency on a Postgres Database.  The dependency has a condition so the Clojure service is only started once the Postgres service is healthy

!!! EXAMPLE "Clojure and Postgres Composure configuration"
    ```yaml
    services:
      clojure-service:
        platform: linux/amd64
        build: ./
        ports: # host:container
          - 8080:8080
        depends_on:
          postgres-database:
            condition: service_healthy

      postgres-database:
        image: postgres:15.2-alpine
        environment:
          POSTGRES_PASSWORD: "$DOCKER_POSTGRES_ROOT_PASSWORD"
        healthcheck:
          test: [ "CMD", "pg_isready" ]
          timeout: 45s
          interval: 10s
          retries: 10
        ports:
          - 5432:5432
    ```

Run the services using docker from the root of the project

!!! NOTE ""
    ```shell
    docker compose up --build
    ```


### File watcher

Docker provides [:globe_with_meridians: `watch`](https://docs.docker.com/compose/file-watch/){target=_blank} as an experimental feature which can rebuild the Clojure service when a file change is detected.  This seems most useful when troubleshooting issues that occur during system integration testing.

Add an `x-develop` configuration with watch under the Clojure service configuration

!!! EXAMPLE "Composure x-develop file watch configuration"
    ```yaml
        x-develop:
          watch:
            - path: ./deps.edn
              action: rebuild
            - path: ./src
              action: rebuild
    ```

Start the services and the file watch mode

!!! NOTE ""
    ```shell
    docker compose up --detach && docker compose alpha watch
    ```

Save changes to files and a new image for the Clojure service will be built and deployed when ready.


## Summary

Docker desktop provides lots of tools to support local system integration work before code is sent to a continuous integration service (or as a temporary alternative if that CI service id down)

Practicalli Project Templates include `Dockerfile`, `.dockerignore` and `compose.yaml` configurations for Clojure development, kick-starting the use of Docker.

Docker images are a relatively clean way of trying out different services or even different operating systems, e.g.[:globe_with_meridians: Ubuntu](https://hub.docker.com/_/ubuntu){target=_blank} or [:globe_with_meridians: ArchLinux](https://hub.docker.com/_/archlinux){target=_blank}.  Deleting the images removes the whole service without affecting the underlying operating system.

[:globe_with_meridians: MegaLinter](https://practical.li/engineering-playbook/code-quality/megalinter/#megalinter-configuration){target=_blank} is an excellent example of a docker image that provides a large number of tools that would otherwise need to be installed directly on the operating system.

- [:globe_with_meridians: Docker Desktop Overview](https://docs.docker.com/desktop/){target=_blank}
- [:globe_with_meridians: Docker Desktop Extensions overview](https://docs.docker.com/desktop/extensions/){target=_blank}
- [:globe_with_meridians: Docker Build overview](https://docs.docker.com/build/){target=_blank}
- [:globe_with_meridians: Docker Compose Overview](https://docs.docker.com/compose/){target=_blank}


---
Thank you.

[:globe_with_meridians: Practical.li Website](https://practical.li){target=_blank .md-button} 

[:fontawesome-brands-github: Practical.li GitHub Org](https://github.com/practicalli){target=_blank .md-button} 
[:fontawesome-brands-github: practicalli-johnny profile](https://github.com/practicalli-johnny){target=_blank .md-button}

[:fontawesome-brands-mastodon: @practicalli@clj.social](https://clj.social/@practicalli){target=_blank .md-button}
[:fontawesome-brands-twitter: @practical_li](https://twitter.com/practcial_li){target=_blank .md-button}
