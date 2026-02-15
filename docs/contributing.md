# Contributing to Practicalli

[:fontawesome-brands-github: Practicalli Kanban board - GitHub Project](https://github.com/orgs/practicalli/projects/8/){target=_blank .md-button}

Practicalli welcomes ideas and constructive feedback for content.  Please reach out to the Practicalli team before making a contribution to avoid disappointment.

All content and interaction with any persons or systems must be done so with respect and within the Practicalli Code of Conduct.

By submitting content ideas and corrections you are to that work becoming the copyright of Practicalli and published under the [:globe_with_meridians: Creative Commons Attribution ShareAlike 4.0 International license](https://creativecommons.org/licenses/by-sa/4.0/){target=_blank}.  Attribution will be detailed via [GitHub contributors](https://github.com/practicalli/practicalli.github.io/graphs/contributors){target=_blank}, pull request and issue history.

!!! Warning "Reaching out to the Practicalli Team before creating a pull request"
    [:fontawesome-brands-github: Raise an issue](https://github.com/orgs/practicalli/projects/8/){target=_blank}, [:fontawesome-brands-github: start a GitHub discussion](https://github.com/orgs/practicalli/discussions) or post a message on the #practicalli channel of [Clojurians Slack community](http://clojurians.net/){target=_blank} to avoid disappointment.


## Content Tools

Practicalli books and websites are written in markdown and uses [:globe_with_meridians: Material for MkDocs](https://squidfunk.github.io/mkdocs-material/){target=_blank} to [:fontawesome-solid-book-open: generate the published website via a GitHub workflow](https://practical.li/engineering-playbook/continuous-integration/github/workflows/practicalli/#mkdocs-publisher).  MkDocs can also run a local server using the `make docs` target from the `Makefile`

The README.md of each project contains install instructions for a local MkDocs server.


## Submit and issue or idea

Each website and book has a link to its GitHub repository in the top-level navigation bar.

Use the [:fontawesome-brands-github: Practicalli Kanban board](https://github.com/orgs/practicalli/projects/8/){target=_blank} to create an issue on any of the Practicalli GitHub repositories.


## Considering a Pull request?

!!! INFO "Pull Request Commits must be cryptographically signed"

All commits contributed to Practicalli must be signed via a legitimate SSH or GPG key to avoid the risk of commit spoofing.

[:fontawesome-solid-book-open: Configure commit signing with SSH key - Practicalli Engineering](https://practical.li/engineering-playbook/source-control/git-configuration/#commit-signing-with-ssh-key){target=_blank .md-button}

All pull requests must include an entry in CHANGELOG.md or will not be merged.  A changelog entry allows the community to follow the changes.

Each pull request will have a number of CI workflows run against the contribution, checking the format of the content and if a changelog entry has been provided.

Please keep pull requests small and focused, as they are much quicker to review and easier to accept.  Ideally PR's should be for a specific page or at most a section.

A PR with a list of changes across different sections will be closed without merging as these take considerable time to review.

Issues such as grammar improvements are typically a sign of a rushed section that requires a rewrite, so a pull request to fix a typeographic error will probably not be merged.  Raise an issue, or post a thread in the [:globe_with_meridians: Clojurians Slack #practicall channel](https://clojurians.slack.com/messages/practicalli)

## Gratitude

A huge thank you to Rich Hickey and the team at Cognitect for creating and continually guiding the Clojure language.

The Clojure community has been highly supportive and I'd like to thank everyone for constructive feedback and contributions.  In particular I would like to thank everyone that joined in with the [London Clojurins community](https://www.meetup.com/London-Clojurians/){target=_blank}, [ClojureBridgeLondon](https://clojurebridgelondon.github.io/){target=_blank}, [Clojurians Slack community](http://clojurians.net/){target=_blank}, [Clojurians Zulip](https://clojurians.zulipchat.com/){target=_blank} community.

I am humbled by those who have sponsored the Practicalli websites and videos, providing financial and motivational support.

Special thanks to [Bruce Durling](https://uk.linkedin.com/in/brucedurling){target=_blank} for getting me into Cloure in the first place.

![GitHub contributors](https://img.shields.io/github/contributors/practicalli/clojure?style=for-the-badge&label=github%20contributors)
