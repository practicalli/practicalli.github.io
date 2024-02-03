---
title: "Safeguard against Git Commit Spoofing"
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

To avoid changing identity each time a spoof is made, [:fontawesome-solid-book-open: multiple git identities](https://practical.li/engineering-playbook/source-control/git-configuration/#multiple-git-identities){target=_blank} can be configured using `includeIf` based on path, so repositories to be spoofed would be kept in the same parent directory.


## Safeguard GitHub account

![Yubikey](https://upload.wikimedia.org/wikipedia/commons/thumb/f/ff/FIDO2_USB_token.png/800px-FIDO2_USB_token.png){align=right loading=lazy style="width:250px"}

Add two Yubikey hardware Security keys as Two-Factor authentication for your GitHub account. One Yubikey for daily work and one kept securely as a backup.

A hardware security key provides greater account protection than Time-based One Time Password (TOTP), i.e. [:globe_with_meridians: Authy app](https://authy.com/download/){target=_blank} or Google Authenticator.

!!! HINT "Use TOTP for initial Two-Factor authentication on GitHub"
    GitHub required an existing form of Two-factor authentication before being able to add a hardware security key, e.g. Yubikey.

    Remove the TOTP authentication once Hardware Security keys have been added for increased account security.


## Safeguard Git Repository

- Limit the number of accounts with write access to the repository
- Sign commits and annotated tags via SSH or PGP keys

Signing commits and tags with SSH keys is the approach covered in the rest of the article.

!!! HINT "GitHub vigilant mode"
    [:globe_with_meridians: Enable GitHub vigilant mode](https://docs.github.com/en/authentication/managing-commit-signature-verification/displaying-verification-statuses-for-all-of-your-commits) to show a verification status badge against all commits, which helps highlight unverified commits.


## Generate SSH Key

Generate an SSH key using the ED25310 type, using a verified email address added to the GitHub user account. 

The SSH key should be created by a passphrase for greater security, saving the passphrase to the operating system key ring for convienience.

!!! NOTE "Generate an SSH Key using ED25310"
    ```shell
    ssh-keygen -t ed25519 -C "name@domain.tld"
    ```

> Ensure the the email account used to create the SSH key is registered and verified in the GitHub user account.


## Add SSH keys to GitHub

Add the public SSH key as an authentication key to push changes to GitHub repositories the account has write access too.

Add the public SSH key as a Signing Key to validate locally signed commits when pushed to GitHub repositories.

[:fontawesome-brands-github: SSH Keys for GitHub account](https://github.com/settings/keys){target=_blank .md-button} 

[:fontawesome-solid-book-open: SSH Key generation - Practicalli Engineering Playbook](https://practical.li/engineering-playbook/source-control/git-configuration/#ssh-key){target=_blank .md-button} 


## Configure Git to Sign commits and tags

Configure the local Git client to automtically sign every commit or annotated tag using an SSH key. e.g. `~/.config/git/config` file.

Create an `allowed-signatures` file and add the public SSH key to the file, prefixing the key with the email address used to create the key.

!!! EXAMPLE "Commit and tag automatic signing with SSH key"
    ```shell title="~/.config/git/config"
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

The private SSH key is automatically used to sign each commit and annotated tag.

With the public SSH key in the `allowedSignersFile` any GitHub client should show that the local commit is signed, i.e. Good "git" signature message.

![Neogit Neovim commit details showing good git signature for SSH signed commit](https://github.com/practicalli/graphic-design/blob/live/editors/neovim/screenshots/neovim-neogit-commit-signed-good-signature-light.png?raw=true#only-light){loading=lazy}
![Neogit Neovim commit details showing good git signature for SSH signed commit](https://github.com/practicalli/graphic-design/blob/live/editors/neovim/screenshots/neovim-neogit-commit-signed-good-signature-dark.png?raw=true#only-dark){loading=lazy}

When the signed commit or tag is pushed to GitHub, the signature is checked against the public key registered with the user account and the change marked as verified if they match.

![GitHub commits history showing verified status](https://github.com/practicalli/graphic-design/blob/live/github/github-commits-history-verified-status.png?raw=true){loading=lazy}

[:fontawesome-solid-book-open: Commit signing with SSH Key - Practicalli Engineering Playbook](https://practical.li/engineering-playbook/source-control/git-configuration/#commit-signing-with-ssh-key){target=_blank .md-button} 


## Summary

As long as the private SSH key is not shared with others, then SSH key signing is a very strong approach to verifying the source of all contributions.


---
Thank you.

[:globe_with_meridians: Practical.li Website](https://practical.li){target=_blank .md-button} 

[:fontawesome-brands-github: Practical.li GitHub Org](https://github.com/practicalli){target=_blank .md-button} 
[:fontawesome-brands-github: practicalli-johnny profile](https://github.com/practicalli-johnny){target=_blank .md-button}

[:fontawesome-brands-mastodon: @practicalli@clj.social](https://clj.social/@practicalli){target=_blank .md-button}
[:fontawesome-brands-twitter: @practical_li](https://twitter.com/practcial_li){target=_blank .md-button}
