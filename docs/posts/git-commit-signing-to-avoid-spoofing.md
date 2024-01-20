---
title: "Safeguard agains Git Commit Spoofing"
date: 2024-01-20
authors:
  - practicalli
categories:
  - git
tags:  
  - git
---

![alternative text](https://github.com/practicalli/graphic-design/blob/live/topic-images/github-logo-name.png?raw=true){align=right loading=lazy style="width:240px"}

Git Commit Spoofing is where a person uses the Git identity of another person to modify commits pushed to GitHub, assuming they can obtain write permission to a branch or via a PR.

Signing is especially useful for those contributing changes via a pull request.  Signing provides greater confidence that the contribution is from a verifyable account.

Working in the Financial sector for many years, signing of commits has become manditory to reduce risk and increase traceability for audit trails.

All Practicalli commits are now signed using a passphrase protected SSH key, registered as a signing key with the GitHub account.  All contributions via pull request should be also be signed, either with GPG or SSH keys.

<!-- more -->

## Safeguard Options

- Limit user accounts with write access to the repository
- Mandate authentication keys on all GitHub accounts, SSH keys with passphrase
- Sign commits and annotated tags via SSH or GPG keys

Signing commits and tags with SSH keys is the approach covered in the rest of the article.

[:globe_with_meridians: Enable vigilant mode](https://docs.github.com/en/authentication/managing-commit-signature-verification/displaying-verification-statuses-for-all-of-your-commits) to show a verification status badge against all commits.


## Spoof a commit

With write access to a shared git repository, spoofing commits is trivial.

Use `git log` to look through the commit history of the repository and copy information from the `Author` field. 

Set the git client configuraiton to be the same as one of the existing author fields to spoof with that account.

!!! NOTE "Set Git Identity"
    ```shell
    git config --global user.email "existing-author@domain.tld"
    git config --global user.name "existing author name"
    ```

Creating a malicious change, stage and create a commit. The Author field on the new commit will be the same as that of the existing commit.

Amending an existing commit is a more likely approach to masking a malicious change than creating a new commit.

Stage the change and then use the `--amend` option to create an updated commit which will still have the existing authors information. 

To avoid changing identity each time a spoof is made, [multiple git identities](https://practical.li/engineering-playbook/source-control/git-configuration/#multiple-git-identities){target=_blank} can be configured using `includeIf` based on path, so repositories to be spoofed would be kept in the same parent directory.


## SSH Keys

Generate an SSH key using the ED25310 type, using a verified email address added to the GitHub user account. The SSH key should be created by a passphrase for greater security, saving the passphrase to the operating system key ring for convienience.

!!! NOTE "Generate an SSH Key"
    ```shell
    ssh-keygen -t ed25519 -C "name@domain.tld"
    ```

[:fontawesome-solid-book-open: SSH Key generation - Practicalli Engineering Playbook](https://practical.li/engineering-playbook/source-control/git-configuration/#ssh-key){target=_blank .md-button} 


## Sign commits and tags

Configure the local Git client to automtically sign every commit or annotated tag, using either an SSH or GPG key.

!!! EXAMPLE "Commit and tag automatic signing with SSH key"
    ```shell
    ## ------ Git Behaviour ------ ##
    [commit]
      # Automatically sign every commit
        gpgsign = true

    [tag]
      # Automatically sign every tag
        gpgsign = true

    # SSH Key signing 
    [user]
        signingkey = ~/.ssh/id_ed25519.pub
    [gpg]
        format = ssh
    [gpg "ssh"]
        allowedSignersFile = ~/.config/git/allowed-signatures
    ```

Add the SSH or GPG public key as a signing key on GitHub.

Ensure the the email account used to create the SSH key is registered and verified in the GitHub user account.

The private SSH key is used to sign each commit and annotated tag.

![Neogit Neovim commit details showing good git signature for SSH signed commit](https://github.com/practicalli/graphic-design/blob/live/editors/neovim/screenshots/neovim-neogit-commit-signed-good-signature-light.png?raw=true#only-light){loading=lazy}
![Neogit Neovim commit details showing good git signature for SSH signed commit](https://github.com/practicalli/graphic-design/blob/live/editors/neovim/screenshots/neovim-neogit-commit-signed-good-signature-dark.png?raw=true#only-dark){loading=lazy}

When the signed commit or tag is pushed to GitHub, the signature is checked against the public key registered with the user account and the change marked as verified if they match.

![GitHub commits history showing verified status](https://github.com/practicalli/graphic-design/blob/live/github/github-commits-history-verified-status.png?raw=true){loading=lazy}

[:fontawesome-solid-book-open: Commit signing with SSH Key - Practicalli Engineering Playbook](https://practical.li/engineering-playbook/source-control/git-configuration/#commit-signing-with-ssh-key){target=_blank .md-button} 


## Summary

As long as the private SSH key is not shared with others, then SSH key signing is a very strong approach to verifying the source of all contributions.

