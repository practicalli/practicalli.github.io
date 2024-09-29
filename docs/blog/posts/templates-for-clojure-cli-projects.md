---
title: "Create deps-new templates for Clojure CLI projects"
date: 2023-03-30
authors:
  - practicalli
categories:
  - clojure-cli
tags:
  - clojure
  - clojure-cli
---

![Practicalli Clojure Logo](https://github.com/practicalli/graphic-design/blob/live/topic-images/clojure-logo-name.png?raw=true){align=right loading=lazy style="width:240px"}


Templates are great way to learn how to assemble Clojure libraries into a working project and can save considerable time when creating new projects by providing common configuration, development tools, dependencies and code used by the engineering team.

[:fontawesome-brands-github: seancorfield/deps-new](https://github.com/seancorfield/deps-new) provides a simple to understand approach to defining templates. Declarative rules express how file templates are copied to create a new project.  Substitution values are passed to `{{unique-key}}` placeholders in template files creating a specific project each time.  Programmatic transformation is also supported for significant customisation, e.g. adding options to templates.

[:fontawesome-brands-github: practicalli/project-templates](https://github.com/practicalli/project-templates) is a new project to provide comprehensive templates to support production level workflows, including Dockerfile configuration, GitHub continuous integration workflows, etc . Read on to see how the first template was built and learn tips to building your own templates.

> deps-new provides a [:fontawesome-brands-github: guide to writing templates](https://github.com/seancorfield/deps-new/blob/develop/doc/templates.md#programmatic-transformation)

<!-- more -->

## Existing templates

`app`, `lib` and `scratch` templates are built into deps-new tool.  Additional template can be used from a local file space or Git repository, e.g. [community templates](https://github.com/seancorfield/deps-new#templates).

deps-new also provides the `template` template to create a project for defining one or more custom project templates, highly recommended if sharing a template via Git repository.

[Practicalli project templates](https://github.com/practicalli/project-templates) provides the `practicalli/service` template to create a production grade HTTP service with Integrant component management system, mulog event logging, reitit routing for APIs, docker, tools.build and make tasks.  More [templates will be added to this project over time](https://github.com/practicalli/project-templates#templates-roadmap).

> deps-new support templates published via a Git service or on the local file space. Templates published via Maven / Clojars are not supported
>
> [:fontawesome-brands-github: seancorfield/clj-new](https://github.com/seancorfield/clj-new) uses the Leiningen template format, providing wide range of project templates, although many of those templates do not include a Clojure CLI configuration.  The clj-new project is not actively maintained.


## Create template project

The deps-new built-in template called `template` will create a new project for creating a custom template (or multiple templates).

`:project/create` alias from [:fontawesome-solid-book-open: Practicalli Clojure CLI Config](https://practical.li/clojure/clojure-cli/practicalli-config/) provides the deps-new tool

Create a new project and specify the template, name of project (the template name) and optionally the directory to create the new project within.

```clojure
clojure -T:project/create :template template :name practicalli/service :target-dir project-templates
```

> `clojure -Tnew template :name practicalli/service` if deps-new was [installed as a Clojure CLI tool](https://github.com/seancorfield/deps-new)


Version control the newly created template project and start customising.


## Use new template

For an effective local development workflow, add the new template project as a dependency via `:local/root`, then template changes are available as they are saved.

```clojure
:project/templates
{practicalli/templates {:local/root "home/practicalli/projects/practicalli/project-templates/"}}
```

Create a new project with this template to test what a new project looks like.

Use the `:project/templates` alias when calling deps-new, e.g. with the `:project/create` alias from [:fontawesome-solid-book-open: Practicalli Clojure CLI Config](https://practical.li/clojure/clojure-cli/practicalli-config/).

Values for `:template` and `:name` keys are required for deps-new when calling deps-new

```shell
clojure -A:project/templates -T:project/create :template practicalli/service :name practicalli/gameboard
```

> The `:name` form is the organisation or developer name / service name


## New Template Overview

The files that make up the template reside under the `resources` directory, e.g. `resources/practicalli/service/` for the Practicalli Service template

* `build` - source of the dependencies, a deps.edn template (`deps.tmpl`) and build script build.clj template (`build.tmpl`)
* `root` - files and directories to be added to the root of the new project
* `src` - files & directories providing default code examples
* `test` - files & directories providing default test code examples
* `template.edn` - values for substitution,  declarative `:transform` rules for copying files and directories to a new project (values optionally used for programmatic transformation)

This is the default structure and can be modified as required.  The `template.edn` should be modified to match any changes in directory structure and file names.

> In the deps-new `template` design, Clojure files with `{{}}` substitution blocks have the `tmpl` extension to avoid errors from tooling that compiles or analyses code, should those files be added to the classpath.
>
> Practicalli uses `.clj.template` and  `.edn.template` file name extensions with Clojure files that contain substitutions to retain the original file name extension and clarity as to the files purpose


## Copy files

deps-new creates a new project by copying all the files from the template using the `:transform` declarative rules.

Files in the `root` directory of the template are copied to the root of the new project by default.

If file names should be transformed or files moved to a different location than root, create a new directory in the template to contain those files and add an explicit rule to the `:transform` section.  Remember to remove the files from the `root` directory, otherwise they will still be copied.

`:transform` key contains declarative rules that define where the contents of each directory in the template is copied to in a new project created from the template, e.g.:

* `"build" ""` copies files in the 'build' directory of the template to the root of a new project
* `"src" "src/{{top/file}}"` copies files to the `src` directory in a sub-directory provided by the template substitution, e.g `src/practicalli/gameboard`


In the Practicalli project templates the `build` files from the original deps-new template were renamed to `deps.edn.template` and `build.clj.template` to include their original filename extension and be very explicitly named.

```edn title="Example template.edn configuration from Practialli Project templates"
[["api" "src/{{top/file}}/{{main/file}}/api"
   {"system_admin.clj.template" "system_admin.clj"
    "scoreboard.clj.template" "scoreboard.clj"}]
  ["build" ""
   {"build.clj.template" "build.clj"
    "deps.edn.template"  "deps.edn"}]
  ["resources" "resources"
   {"config.edn.template" "config.edn"}]
  ["src" "src/{{top/file}}/{{main/file}}"
   {"middleware.clj.template" "middleware.clj"
    "parse_system.clj.template" "parse_system.clj"
    "router.clj.template" "router.clj"
    "service.clj.template" "service.clj"}]
  ["test" "test/{{top/file}}/{{main/file}}"
   {"service_test.clj.template" "service_test.clj"}]]
```

The `:only` keyword added to the end of a transform mapping will only copy a specified file from the directory, ignoring all other files.  `:raw` keyword will not use any substitution on that file, useful for binary files any files that use the `{{}}` substitution for purposes other than creating projects with deps-new.


!!! HINT "Service Template - change to resources directory"
    practicalli/service template includes a `resources/config.edn.template` that will be copied to `resources/config.edn` in a new project.  The existing `resources` directory in `root` was removed to ensure `resources/.keep` is not copied to the new project.



## Substitution

`{{key}}` in any of the copied files will substitute the value associated with `:keyword`, if that key is found in:

* [:fontawesome-brands-github: available options](https://github.com/seancorfield/deps-new/blob/develop/doc/options.md) lists optional keys to override template defaults
* [:fontawesome-brands-github: project names and variables](https://github.com/seancorfield/deps-new/blob/develop/doc/names-variables.md) lists derived, environmental and scm variables that can be used as substitutions
* `template.edn` file of the template in use


`"{{description}}"` substitutes the value associated with the `:description` key from the `template.edn` file or command-line argument.  Typically used in the project readme.md file and/or the comment header of the main namespace

`(ns {{top/ns}}.{{main/ns}})` substitutes the fully qualified namespace within an ns expression, creating the project specific namespace for source and test files.

`{{raw-name}}` uses value from `:name` passed as an argument

The following sub-sections show examples from the [:fontawesome-brands-github: Practicalli Project templates](https://github.com/practicalli/project-templates/tree/main/resources/practicalli) for ideas on how to use these substitutions


### Namespace and File names

Clojure projects need to use the correct case in file names (snake_case) and namespace `ns` definitions (kebab-case).

Appending any unqualified substitution keyword with `/ns` or `/file` will use the correct case

* `{{unqualified-key/ns}}` - hyphenated words use kebab-case, e.g. for `ns` and `require` expressions
* `{{unqualified-key/file}}` - hyphenated words use snake_case, e.g. for use as a filename or directory path

Use `{{top/ns}}` and `{{main/ns}}` substitutions to create a namespace form using the values derived from the `:name` value provided on the command line when creating a new project

```clojure
(ns {{top/ns}}.{{main/ns}}.service
  "Gameboard service component lifecycle management"
  (:gen-class)
  (:require
   ;; Application dependencies
   [{{top/ns}}.{{main/ns}}.router :as router]
   ;; Component system
   [{{top/ns}}.{{main/ns}}.parse-system :as parse-system]
   ;; System dependencies
   [org.httpkit.server     :as http-server]
   [com.brunobonacci.mulog :as mulog]))
```

`{{top/file}}` and `{{main/file}}` are used in the template.edn to use the correct case for file names, derived from the :name value given when creating the project.

```edn title="Example template.edn configuration from Practialli Project templates"
[["api" "src/{{top/file}}/{{main/file}}/api"
   {"system_admin.clj.template" "system_admin.clj"
    "scoreboard.clj.template" "scoreboard.clj"}]
  ["build" ""
   {"build.clj.template" "build.clj"
    "deps.edn.template"  "deps.edn"}]
  ["resources" "resources"
   {"config.edn.template" "config.edn"}]
  ["src" "src/{{top/file}}/{{main/file}}"
   {"middleware.clj.template" "middleware.clj"
    "parse_system.clj.template" "parse_system.clj"
    "router.clj.template" "router.clj"
    "service.clj.template" "service.clj"}]
  ["test" "test/{{top/file}}/{{main/file}}"
   {"service_test.clj.template" "service_test.clj"}]]
```


### Build files directory

In the Practicalli Project templates, `deps.edn.template` is a Clojure CLI `deps.edn` configuration file which provides several aliases to support development.

* `:run/service` starts the service by running the `-main` function from the main namespace
* `:run/greet` calls the `greet` function, an example of using `clojure.exec`
* `:test/env` is a placeholder for adding libraries which would support the testing of the service.
* `:test/run` starts the kaocha test runner and runs all the unit tests within the `test` path (stops on first failing test) and can also be used with CI service
* `:build` runs the given build task (defined in `build.clj`), e.g. `clojure -T:build uberjar`

The `:run/service` uses a substitution to specify the fully qualified main namespace

```clojure
  :run/service
  {:main-opts ["-m" "{{top/ns}}.{{main/ns}}"]}
```


### Root files

`README.md`, `CHANGELOG.md`, `.gitignore` and `pom.xml` are provided by the deps-new template.

* `README.md` uses the `{{raw-name}}` as the title and `{{description}}` as the project description

The Practicall service template updates the `root` files and adds many others that support the Practicalli workflow

The following files were added to the `resources/practicalli/service/root` directory

* `.cljstyle` configuration for Cljstyle linter
* `.dockerignore` configuration to manage files copied to docker images
* `.dir-local.el` Clojure CLI aliases to use with the Emacs Cider jack-in command
* `dev/user.clj` for development tools
  - launches Portal data inspector, listening on nREPL and displays all evaluation results
  - Mulog event log with publisher to send event logs to portal
  - find-deps to search for Clojure libraries


### src and test

The locations to copy the src and test files in a new project are defined in the `:transform` section of the `template.edn` file.

In each file within `src` and `test`, the namespace definition uses substitution to define the correct namespace

In the `src/`service.clj.template:

```clojure
(ns {{top/ns}}.{{main/ns}}
  (:gen-class)
  (:require
    [com.brunobonacci.mulog :as mulog]))
```

In the `test/service.clj.template` the ns expression uses substitution before the `-test` postfix on the namespace.

The service namespace from source is also added via substitution

```clojure
(ns {{top/ns}}.{{main/ns}}-test
  (:require [clojure.test :refer [deftest is testing]]
            [{{top/ns}}.{{main/ns}} :as {{main/ns}}]))
```


## Custom substitution

Add key value pairs in `template.edn` for custom substitutions, e.g. defining the version of Clojure

```clojure
{;; Values to pass into the template
 :description "TODO: Provide a meaningful description of the project"

 ;; Custom substitutions
 :clojure-version "1.11.1"

 ;; Programatic Transformation functions
 :data-fn practicalli.service/data-fn
 :template-fn practicalli.service/template-fn

 ;; Declarative Transformation rules
 :transform
 [[,,,]]}
```

The `deps.edn.template` can then use substitution to include the desired version of Clojure

```clojure title="deps.edn.template"
 :deps
 {org.clojure/clojure {{clojure-version}}}
```

When using the template to create a project, the custom key can be given a different value as a command line option

```shell
clojure -T:project/create :template practicalli/application :name practicalli/playground :clojure-version "1.12.0-alpha"
```


## Test templates

Each template should have a unit test that checks the `template.edn` file against the [deps-new specification](https://github.com/seancorfield/deps-new/blob/develop/src/org/corfield/new.clj)

Tests can be run with a Clojure test runner, e.g. kaocha test runner using `:test/run` alias from Practicalli Clojure CLI Config.

```shell
clojure -X:test/run
```

In Practicalli Project Templates, `src/practicalli/service_test.clj` defines a unit test with `clojure.test` and `clojure.spec`, which test the `practicalli/template/service/template.edn` configuration.

> A unit test is provides when creating a new project via the deps-new template


## Publish and Use template

Push the new project with custom template to a shared Git service (GitHub, GitLab, etc.)

Create a release with a Git tag version and a meaningful description, e.g. using the GitHub releases page <https://github.com/practicalli/project-templates/releases>

A alias could be used to add the new template project in the user `deps.edn` configuration

```clojure
  :project/templates
  {extra-deps:
   {io.github.practicalli/project-templates {:git/tag "2023.04.19" :git/sha "975e771"}}}
```

However, it is simpler to include the new template project as a dependency within the alias to run deps-new, e.g. `:project/create` alias definition.

```clojure
  :project/create
  {:replace-deps {io.github.seancorfield/deps-new
                  {:git/tag "v0.5.1" :git/sha "48bf01e"}
                  io.github.practicalli/project-templates
                  {:git/tag "2023.04.19" :git/sha "975e771"}}
   :exec-fn org.corfield.new/create
   :exec-args {:template practicalli.template/application
                  :name practicalli/playground}}
```

> Default values for template.edn keys can be defined in the `:exec-args {}` of an alias for the project template.  These values will be overridden by matching key values passed via the command line


The command to create a new project is greatly simplified

```shell
clojure -T:project/create
```

Providing a specific project name will override the default `:name` value

```shell
clojure -T:project/create :name practicalli.template/gameboard
```

And specifying a template will override the default `:template` value

```shell
clojure -T:project/create :template practicalli/application :name practicalli.template/gameboard
```

> [Practicalli Clojure CLI Config](https://practical.li/clojure/clojure-cli/practicalli-config/) has been updated to include the [practicalli/project-templates](https://github.com/practicalli/project-templates) dependency, making available all the Practicalli templates.


## Multiple template project

Multiple templates can be added to the same project, especially if they are logically connected (e.g. part of the same team or organisation).

A single dependency can be used if all templates are available in the same project.

Each template is referred to via its namespace, e.g. `practicalli/service`, `practicalli/application`, etc.

- `resources/practicalli/new-template-name`: add all the code and configuration for the new project, typically following the `build`, `root`, `src` and `test` directory name convention
- `src/practicalli/`: add `template_name.clj`
- `test/practicalli/`: add `template_name_test.clj`


## Summary

[:fontawesome-brands-github: seancorfield/deps-new](https://github.com/seancorfield/deps-new) template provides a fast way to start creating your own templates, which can quickly be assembled from code and configuration in existing project.

[:fontawesome-brands-github: Practicalli project templates](https://github.com/practicalli/project-templates) provides an example of how comprehensive a template can be with very simple declarative rules.


deps-new also provides [:fontawesome-brands-github: Programmatic transformation](https://github.com/seancorfield/deps-new/blob/develop/doc/templates.md#programmatic-transformation) for more advanced transformation.

A `data-fn` function is provided to modify the available substitution data and the `transform-fn` to modify the `template.edn` structure.

`transform-fn` could be used to update the declarative rules that control the file copying, using alternative source code and configuration files based on optional values passed into the template, e.g. `:persistence :postgres` command line option would use source code files that included `next.jdbc`, postgres library as a dependency and code to manage and query the database.


---
Thank you.

[:globe_with_meridians: Practical.li Website](https://practical.li){target=_blank .md-button}

[:fontawesome-brands-github: Practical.li GitHub Org](https://github.com/practicalli){target=_blank .md-button}
[:fontawesome-brands-github: practicalli-johnny profile](https://github.com/practicalli-johnny){target=_blank .md-button}

[:fontawesome-brands-mastodon: @practicalli@clj.social](https://clj.social/@practicalli){target=_blank .md-button}
[:fontawesome-brands-twitter: @practical_li](https://twitter.com/practcial_li){target=_blank .md-button}
