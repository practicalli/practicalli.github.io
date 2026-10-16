# Contribute to Practicalli work

[:fontawesome-brands-github: Practicalli Kanban board - GitHub Project](https://github.com/orgs/practicalli/projects/8/){target=_blank .md-button}

All content and interaction with any persons or systems must be done so with respect and within the Practicalli Code of Conduct.

All ideas and content submitted becomes copyright of Practicalli and published under the [:globe_with_meridians: Creative Commons Attribution ShareAlike 4.0 International license](https://creativecommons.org/licenses/by-sa/4.0/){target=_blank}.

Attribution will be detailed via [GitHub contributors](https://github.com/practicalli/practicalli.github.io/graphs/contributors){target=_blank}, pull request and issue history.

!!! WARNING "Reach out to the Practicalli Team before creating a pull request"
    [:fontawesome-brands-github: Raise an issue](https://github.com/orgs/practicalli/projects/8/){target=_blank}, [:fontawesome-brands-github: start a GitHub discussion](https://github.com/orgs/practicalli/discussions) or post a message on the #practicalli channel of [Clojurians Slack community](http://clojurians.net/){target=_blank} to avoid disappointment.


## Content Tools

Practicalli books and websites are written in Python flavor markdown.

[:fontawesome-solid-book-open: Zensical Static site generator](https://practical.li/engineering-playbook/technical-writing/static-site/zensical/){target=_blank} generates the published website via a GitHub CI workflow](https://practical.li/engineering-playbook/tools-services/continuous-integration/github/workflow/practicalli/#zensical-static-site-generator).

Zensical can run a local 'reloading' server to support content development, using the `make docs` target from the `Makefile`.

The README.md of each project contains install instructions for a local Zensical server.


## Issue and ideas

Each website has a link to its GitHub repository in the footer of each page.

Use the [:fontawesome-brands-github: Practicalli Kanban board](https://github.com/orgs/practicalli/projects/8/){target=_blank} to create an issue on any of the Practicalli GitHub repositories.


## Pull request

!!! INFO "All commits must be cryptographically signed"

All commits contributed to Practicalli must be signed via a legitimate SSH or GPG key to avoid the risk of commit spoofing.

[:fontawesome-solid-book-open: Configure commit signing with SSH key - Practicalli Engineering](https://practical.li/engineering-playbook/source-control/git-configuration/#commit-signing-with-ssh-key){target=_blank .md-button}

All pull requests must include an entry in `CHANGELOG.md` or will not be merged. A changelog entry allows the community to follow the changes.

Several GitHub CI workflows run against a PR, checking the format of the content and ensure a changelog entry has been provided.

Please keep pull requests small and focused so they are quick to review and accept. Ideally PR's should be for a specific page or at most a section.

!!! INFO "Typographic errors unlikely to be merged"
    This type of issue indicates a rushed section that requires a rewrite, rather than simply fix a few words.
    Practicalli books were started over a decade and older content my need a significant rewrite.


## Gratitude

A huge thank you to all the communities and colleagues that have supported the work published by Practicalli.

The Clojure community has been highly supportive, especially people who joined in with the [London Clojurins community](https://www.meetup.com/London-Clojurians/){target=_blank}, [ClojureBridgeLondon](https://clojurebridgelondon.github.io/){target=_blank}, [Clojurians Slack community](http://clojurians.net/){target=_blank}, [Clojurians Zulip](https://clojurians.zulipchat.com/){target=_blank} community.

I am humbled by those who have sponsored the Practicalli websites and videos, providing financial and motivational support.

Special thanks to [Bruce Durling](https://uk.linkedin.com/in/brucedurling){target=_blank} for getting me into Cloure in the first place.

Many thanks to the organisers and members of the London Java Community for their support as I started my developer advocacy journey.

![GitHub contributors](https://img.shields.io/github/contributors/practicalli/clojure?style=for-the-badge&label=github%20contributors)
