# Unreleased

## Added
- dev: CNAME for custom GitHub pages domain
- intro: standard sponsor message
- post: essential tools for clojure development
- readme: book status, description and local build steps
- intro: add writing tips page (from Practicalli Clojure)
- post: updated London Clojurians brief history
- intro: semper scribus badge & button link logos
- dev: megalinter runner upgrade make task
- writing-tips: examples of annotations within admonitions
- mkdocs: round corners style for buttons etc
- intro: add code of respect
- dev: stale issue & pr scheduled check (monthly)
- intro: lexers for markdown code block syntax highlights in writing tips
- intro: warning not to embed file from same repository in code block
- dev: github issue templates

## Changed
- mkdocs: correct github url for repo and edit link
- dev: megalinter upgrade to version 8
- dev: update mkdocs targets to use python virtual environment
- mkdocs: refactor main nav, add personal journal link
- dev: update github actions with `make dependencies-update`

| :file                                          | :name                   | :current | :latest |
|------------------------------------------------|-------------------------|----------|---------|
| .github/workflows/changelog-check.yaml         | actions/checkout        | v5       | v6.0.2  |
| .github/workflows/megalinter.yaml              | actions/checkout        | v5       | v6.0.2  |
|                                                | actions/upload-artifact | v4       | v7.0.1  |
| .github/workflows/publish-book.yaml            | actions/cache           | v4       | v5.0.4  |
|                                                | actions/checkout        | v5       | v6.0.2  |
| .github/workflows/scheduled-version-check.yaml | actions/checkout        | v5       | v6.0.2  |
