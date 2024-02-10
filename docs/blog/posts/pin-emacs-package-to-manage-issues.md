---
title: "Pin Emacs packages to manage issues"
date: 2023-08-15
authors:
  - practicalli
categories:
  - emacs
tags:
  - emacs
  - spacemacs
---

![Practicalli Clojure Logo](https://github.com/practicalli/graphic-design/blob/live/topic-images/emacs-logo-name.png?raw=true){align=right loading=lazy style="width:240px"}

Emacs provides a huge amount of features via packages. Community configurations like Spacmacs orchestrate packages so they work seemlessly together.  It is rare, but sometimes a package will have a breaking issue.

[Melpa](https://melpa.org/#/) provides (5,544) up-to-date packages  automatically built from each projects Git repository. Builds are defined by a recipe for each package.

A custom recipe can be used to control which version of a package is used with the Emacs configuration, to work around issues or changes to a package.

<!-- more -->

## Melpa recipes

Search for packages on the Melpa website and view its recipe to understand how it is built.

!!! EXAMPLE "Emacs Package Recipe from Melpa"
    ```elisp
    (treemacs
     :fetcher github
     :repo "Alexander-Miller/treemacs"
     :files (:defaults
             "Changelog.org"
             "icons"
             "src/elisp/treemacs*.el"
             "src/scripts/treemacs*.py"
             (:exclude "src/extra/*")))
    ```

Melpa will build the package from the lastest commit.

`:commit` with a specific Git SHA value can be used to specify a different commit, especially useful for using an earlier package known to be issue free.

> Visit the shared Git repository of the package and review the commit history to find a likely working package.


## Custom recipe in Spacemacs

Spacemacs uses packages from Melpa so the latest package versions are downloaded when Spacemacs is installed.

Users of Spacemacs can decide when to update packages by manually running a package update, `SPC f e U`, usually when a new feature in a package is desirable.

If there is an issue with updated package, then run a package rollback via the link on the Spacemacs home buffer, `SPC b h`.

If the majority of package updates are required, then a specific package version can be pinned by providing a custom recipe.

Add a custom recipe to the Spacemacs user configuration, to the `dotspacemacs-additional-packages`.

Move the newest package version from the `elpa/<emacs-version>/develop/` directory to trigger a package download when Emacs is restarted.

!!! EXAMPLE "Example package pin"
```elisp
   dotspacemacs-additional-packages
   '((treemacs
      :location (recipe
                 :fetcher github
                 :repo "Alexander-Miller/treemacs"
                 :commit "2c576bebccd56ec8e65f4ec5ed5de864d9684fbf"
                 :files (:defaults
                         "Changelog.org"
                         "icons"
                         "src/elisp/treemacs*.el"
                         "src/scripts/treemacs*.py"
                         (:exclude "src/extra/*")))))
```


!!! HINT "Update Spacemacs only when there is a need"
    Practicalli recommends Spacemacs packages should be updated only when there is a known new feature or bug fix available.

    Avoid updating packages when your time is constrained, so there is scope to resolve a potential error.


## Copy package from rollback cache

Spacemacs saves a short history of package files in the `.cache/.rollback/<emacs-version>/develop/<rollback-date>`

Rather than use a custom recipe or revert all updated packages, a specific package can be copied from the rollback cache, removing the newer package.

For example:

```shell
cp -r ~/.config/emacs/.cache/.rollback/28.3/develop/23-08-10_07.35.07/treemacs-20230703.1929/ ~/.config/emacs/elpa/28.3/develop/
```


## Summary

Issues with Emacs packages are quite rare from experience and often solved very quickly.

A Package rollback in Spacemacs is a very quick way to resolve an issue.  Pinning a package using a custom recipe a little more involved, although still a relatively quick approach if the error messages identify a troubled package.

The Spacemacs community is very large so issues are reported quickly.  Even if the issue is not a simple resolution then collectively the issue is solved quite rapidly.


---
Thank you.

[:globe_with_meridians: Practical.li Website](https://practical.li){target=_blank .md-button} 

[:fontawesome-brands-github: Practical.li GitHub Org](https://github.com/practicalli){target=_blank .md-button} 
[:fontawesome-brands-github: practicalli-johnny profile](https://github.com/practicalli-johnny){target=_blank .md-button}

[:fontawesome-brands-mastodon: @practicalli@clj.social](https://clj.social/@practicalli){target=_blank .md-button}
[:fontawesome-brands-twitter: @practical_li](https://twitter.com/practcial_li){target=_blank .md-button}

