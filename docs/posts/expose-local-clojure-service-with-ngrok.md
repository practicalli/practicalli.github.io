---
title: "Expose Clojure Service using Ngrok"
date: 2023-08-24
authors:
  - practicalli
categories:
  - clojure
tags:
  - clojure
  - ngrok
---

Exposing a local running services can be valuable when writing apps and web-hooks for Cloud API products, e.g. Slack, Atlassian Confluence, Hasura, Salesforce, etc.

ngrok exposes local networked services behinds NATs and firewalls to the public internet over a secure tunnel.

[Create a free ngrok account](https://ngrok.com/signup) to get an authorisation token for use with the ngrok agent to create a secure tunnel.  Or add an SSH public key to use SSH reverse tunnel with the ngrok service.

<!-- more -->

ngrok has additional [paid services](https://ngrok.com/pricing), although they are not required for exposing local services.


## Example Clojure Service

[Practicalli Clojure CLI Config](https://practical.li/clojure/clojure-cli/practicalli-config/) defines the `:project/create` alias to generate a new project from a template.  The `practicalli/service` template creates a project for developing web services with a REST API.

Create a project called gameboard using donut system to manage service components

```shell
clojure -T:project/create :template practicalli/service :name practicalli/gameboard :component donut
```

Change into the `gameboard` directory

`make run` (`clojure -M:run/service`) to run the service locally, serving an API endpoint on [http://localhost:8080](http://localhost:8080)

> Alternatively, `make docker-build` to run the service via a docker container (assuming Docker is running locally).


## Install ngrok

Linux (apt) operating system, add a ngrok repository key and install the ngrock package

```shell title="Install on Apt based Linux operating system"
curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | \
  sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null && \
  echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | \
  sudo tee /etc/apt/sources.list.d/ngrok.list && \
  sudo apt update && sudo apt install ngrok
```

MacOS install with HomeBrew:

```shell
brew install ngrok/ngrok/ngrok
```

> [Ngrok download page](https://ngrok.com/download) for other installation options or use an SSH reverse tunnel without need to install the ngrok agent.


## Setup ngrok

[Create an account](https://ngrok.com/signup) with multi-factor authentication.

Login to the Ngrok dashboard to obtain the Authtoken (tunnel credential) for the ngrok account.  The token is used by the ngrok agent to log into the ngrok account when starting a tunnel.

```shell
ngrok config add-authtoken TOKEN
```

> Claim a free [static domain](https://dashboard.ngrok.com/cloud-edge/domains) to avoid random URLs. Creating a domain of your own choosing is a paid service on ngrok.


### ngrok config file

Use a configuration file to define one or more tunnels for use with the ngrok agent.

Open the default ngrok configuration file for editing:

```shell
ngrok config edit
```

Or open the yaml file from the default configuration location

- Linux: `~/.config/ngrok/ngrok.yml`
- MacOS (Darwin): `~/Library/Application Support/ngrok/ngrok.yml`

```yaml
authtoken: ***************************_*********************
version: 2
tunnels:
  custom_tunnel_name:
    proto: http
    hostname: free-static-domain-name.ngrok-free.app
    addr: 127.0.0.1:8080

    # -------------------------
    # Additional options
    # -------------------------
    # auth: "username:password"
    # host_header: rewrite
    # inspect: true
    # bind_tls: true
```

> [ngrok agent configuration file documentation](https://ngrok.com/docs/secure-tunnels/ngrok-agent/reference/config/)

Start the tunnel using the command line.

```shell
ngrok start custom_tunnel_name
```

Or start all tunnels in the configuration file

```shell
ngrok start --all
```


## Inspecting traffic

Open [http://localhost:4040](http://localhost:4040) to view the ngrok web interface, allowing inspection of traffic over the secure HTTP tunnel (TCP & TLS tunnel inspection not supported).

The web interface lists each request through the tunnel and selecting a request shows all the details of that request.

- Request body validation (JSON, XML data)
- Filter requests on request path, response status code, response body size, request duration, or any header value
- Replay requests, optionally modifying a request first
- [ngrok agent status](http://localhost:4040/status) to help with troubleshooting the tunnel connetion

![Ngrok web inspection interface](https://ngrok.com/docs/assets/images/inspect2-91853c29eecae917896a429455b02111.png)

[Ngrok web inspection interface](https://ngrok.com/docs/secure-tunnels/ngrok-agent/web-inspection-interface/)

## SSH reverse tunnel

ngrok can be used with SSH reverse tunneling (ssh -R), avoiding the need to install the ngrok agent.

Add an SSH public key to the ngrok dashboard, **Tunnels** > **SSH Public Keys**

Run the command to open an SSH reverse tunnel to ngrok

```shell
ssh -R 443:localhost:80 tunnel.us.ngrok.com http
```

> [SSH reverse tunnel agent documentation](https://ngrok.com/docs/secure-tunnels/tunnels/ssh-reverse-tunnel-agent/)


## ngrok Docker service

Use a Docker image containing ngrok to avoid installing the ngrok agent.

ngrok provides the [ngrok/ngrok](https://hub.docker.com/r/ngrok/ngrok) docker image.  Practicalli recommends using the alpine image variant for minimal resource use.

```shell
docker run -it -e NGROK_AUTHTOKEN=$NGROK_AUTH_TOKEN ngrok/ngrok:alpine http 8080 --domain=free-static-domain-name.ngrok-free.app
```

Add an ngrok service to Docker `compose.yaml`, optionally adding a volume and port configuration.

To manage ngrok configuration effectively, add an `ngrok.yml` configuration to the root of the directory where the ngrok image is to be run.  The `ngrok.yml` config is mounted to `/etc/ngrok.yml` in the Docker container, allowing an simple way to update the config.

```yaml title="compose.yaml"
services:
    ngrok:
        image: ngrok/ngrok:alpine
        restart: unless-stopped
        command:
          - "start"
          - "--all"
          - "--config"
          - "/etc/ngrok.yml"
        volumes:
          - ./ngrok.yml:/etc/ngrok.yml
        ports:
          - 4040:4040
```

Run all the services defined in the Docker `compose.yml` file, optionally with the `--detatch` flag to run in the background of the shell.

```shell
docker compose up --detatch
```

Or run only the ngrok service

```shell
docker compose up --detatch ngrok
```

> Add an ngrok service to a [Docker compose configuration to build & run the clojure service](https://practical.li/engineering-playbook/continuous-integration/docker/compose/) in conjunction with a [multi-stage dockerfile](https://practical.li/engineering-playbook/continuous-integration/docker/clojure-multi-stage-dockerfile/).

[Using ngrok with Docker](https://ngrok.com/docs/using-ngrok-with/docker/)


## Secure public endpoints

ngrok agent allows security to be dynamically added to any public endpoint, with IP restrictions

- HTTP Basic Authentication
- OAuth 2.0
- OpenID Connect
- SAML
- Webhook Verification
- Mutual TLS


## Summary

ngrok is a secure way to expose locally running services that integrate with cloud services and can help speed development by providing faster feedback than running a full deployment cycle.

ngrok agent works on multiple operating systems and can be run in a Docker container.  An SSH reverse tunnel can be used for zero agent install approach.

Using ngrok only because the continuous integration process is very time consuming is a strong indication that time should be invested in improving the CI workflow, ensuring the minimal amount of work is required to create a repeatable build.

[practicalli GitHub profile](https://github.com/practicalli) I [@practical_li](https://twitter.com/practical_li)

---
Thank you.

[:globe_with_meridians: Practical.li Website](https://practical.li){target=_blank .md-button} 

[:fontawesome-brands-github: Practical.li GitHub Org](https://github.com/practicalli){target=_blank .md-button} 
[:fontawesome-brands-github: practicalli-johnny profile](https://github.com/practicalli-johnny){target=_blank .md-button}

[:fontawesome-brands-mastodon: @practicalli@clj.social](https://clj.social/@practicalli){target=_blank .md-button}
[:fontawesome-brands-twitter: @practical_li](https://twitter.com/practcial_li){target=_blank .md-button}
