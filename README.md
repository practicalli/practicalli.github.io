# Practicalli Software Development

Software development guides and live coding screencasts, with a focus on the Clojure programming language.


```none
██████╗ ██████╗  █████╗  ██████╗████████╗██╗ ██████╗ █████╗ ██╗     ██╗     ██╗
██╔══██╗██╔══██╗██╔══██╗██╔════╝╚══██╔══╝██║██╔════╝██╔══██╗██║     ██║     ██║
██████╔╝██████╔╝███████║██║        ██║   ██║██║     ███████║██║     ██║     ██║
██╔═══╝ ██╔══██╗██╔══██║██║        ██║   ██║██║     ██╔══██║██║     ██║     ██║
██║     ██║  ██║██║  ██║╚██████╗   ██║   ██║╚██████╗██║  ██║███████╗███████╗██║
╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝   ╚═╝   ╚═╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚══════╝╚═╝
```


## Status

[![MegaLinter](https://github.com/practicalli/practicalli.github.io/actions/workflows/mega-linter.yml/badge.svg)](https://github.com/practicalli/practicalli.github.io/actions/workflows/mega-linter.yml)
[![Publish Zensical Docs](https://github.com/practicalli/practicalli.github.io/actions/workflows/docs.yml/badge.svg)](https://github.com/practicalli/practicalli.github.io/actions/workflows/docs.yml)

![GitHub commit activity](https://img.shields.io/github/commit-activity/m/practicalli/practicalli.github.io?style=for-the-badge)
![GitHub contributors](https://img.shields.io/github/contributors/practicalli/practicalli.github.io?style=for-the-badge&label=github%20contributors)

## Creative commons license

<div style="width:95%; margin:auto;">
  <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" /></a>
  This work is licensed under a Creative Commons Attribution 4.0 ShareAlike License (including images & stylesheets).
</div>

## Contributing

Please read the [detailed Practicalli contributing page](https://practical.li/contributing/) before raising an issue or pull request to avoid disappointment.

[![Ideas & Issues](https://img.shields.io/github/issues/practicalli/practicalli.github.io?label=content%20ideas%20and%20issues&logoColor=green&style=for-the-badge)](https://github.com/practicalli/practicalli.github.io/issues)
[![Pull requests](https://img.shields.io/github/issues-pr/practicalli/practicalli.github.io?style=for-the-badge)](https://github.com/practicalli/practicalli.github.io/pulls)

By submitting content ideas and corrections you agree they can be used in any work by Practicalli under the [Creative Commons Attribution ShareAlike 4.0 International license](https://creativecommons.org/licenses/by-sa/4.0/).

Attribution is detailed via [GitHub contributors](https://github.com/practicalli/practical.li/graphs/contributors).


## Sponsor Practicalli

[![Sponsor Practicalli via GitHub](https://raw.githubusercontent.com/practicalli/graphic-design/live/buttons/practicalli-github-sponsors-button.png)](https://github.com/sponsors/practicalli-johnny/)

All sponsorship funds are used to support the continued development of [Practicalli series of books and videos](https://practical.li/), although most work is done at personal cost and time.

Thanks to [Nubank](https://nubank.com.br/) and a wide range of other [GitHub sponsors](https://github.com/sponsors/practicalli-johnny#sponsors) for their continued support


## GitHub Actions

The megalinter GitHub workflow runs when a pull request is created, checking markdown syntax and links.

A review of the change will be carried out by the Practicalli team and the PR merged if the change is acceptable.

The Docs workflow will run when PR's are merged into main (or the Practicalli team pushes changes to the default branch).

The Docs workflow installs UV and runs Zensical as a tool to build the site. GitHub actions are used to create a new pages deployment.


## Local development

Zensical can be installed locally via vu or pip.  Practicalli uses uv and installs Zensical as a tool for simplicity.

CLI Commands are wrapped in tasks defined within the `Makefile`, providing a simpler and consistent user experience.

[Zensical - Practcialli Engineering Playbook](https://practical.li/engineering-playbook/technical-writing/static-site/zensical/)

Clone the repository and change into the root of the project.

```shell
git clone https://github.com/practicalli/cycling
```

Install Zensical as a tool using `uv` (updating if there is a new version).

```shell
make docs-install
```

Or use the uv command:

```shell
uv tool install zensical --with catppuccin-zensical --upgrade
```


Build the website and serve locally at [http://localhost:8000](http://localhost:8000)

```shell
make docs
```

Or use the zensical command:

```shell
zensical serve --dev-addr localhost:7777
```

---

Specific command if now using make:

Create a virtual python in the root of the project.

```shell
uv tool install zensical --upgrade
```
