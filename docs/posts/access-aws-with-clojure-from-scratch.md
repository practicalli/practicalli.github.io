---
title: "Accessing AWS with Clojure from scratch - simple approach"
date: 2023-05-17
topic: aws
tags:  
  - aws
  - clojure
  - cognitect-labs
---

![alternative text](https://github.com/practicalli/graphic-design/blob/live/topic-images/aws-logo-name.png?raw=true){align=right loading=lazy style="width:240px"}

[Cognitect Labs AWS API](https://github.com/cognitect-labs/aws-api) is an excellent data driven Clojure library for interacting with AWS from code.  Essentially a client for an AWS Service is created which operations are invoked.  The project includes working code examples (_once a working AWS account is configured_).

The hardest is configuring suitable AWS accounts, programmatic access and service permissions, especially when new to AWS.  This article starts with nothing and steps through the simplest and quickest AWS account and permission setup, using the ["AWS Free Tier"](https://aws.amazon.com/free/).  Note: every service has quota limits and some services are only free for a period of time (free trials & 12 months free).

The approach outlined is not intended for commercial work, only the bare essentials to start exploring what is possible with the Cognitect Labs library.  (Or you could try out [LocalStack if you have docker installed locally](https://localstack.cloud/)).

<!-- more -->

!!! WARNING "Avoid this approach for sesitive accounts" 
    Avoid approach for personal or company projects containing sensitive information**

!!! WARNING "Credit card required"
    A working credit card is required to setup a root account and AWS will charge the card $1 to verify identity and that the card is legitimate.  This amount will be returned within 3-5 days.

    Apart from the temporary charge, this approach should not incur any charges so long as the account stays within the free plan limits.  Recommend using a digital card that can be set to frozen when not explicitly used as a safety precaution.


## Create Root account

A root account is used for administration of an Amazon Web Service (AWS) account. This includes management of IAM accounts which are used for day to day work and programmatic (code) access.

Create a root account by [singing up for AWS](https://portal.aws.amazon.com/billing/signup#/start/email)

Enter an email for the root account and a name for the AWS account

![AWS Sign up website](https://github.com/practicalli/graphic-design/blob/live/cloud-services/aws/aws-sign-up-webpage.png?raw=true)

An email is sent to the address entered with a verification code.  Enter the code and select **Verify**

![AWS sign up website - verify code](https://github.com/practicalli/graphic-design/blob/live/cloud-services/aws/aws-sign-up-webpage-confirm-verification-code.png?raw=true)

Generate a secure password for the root account, e.g. using a Password Manager such as NordPass or 1Password

![AWS sign up website - set root account password](https://github.com/practicalli/graphic-design/blob/live/cloud-services/aws/aws-sign-up-webpage-root-password.png?raw=true)

> Save the account password with your favourite password manager


Select **Personal** plan as this account is only used for personal projects & hacking (not cracking).

Complete contact information with your actual details (used when AWS confirms the credit card is legitimate) and confirm the [AWS Customer Agreement](https://aws.amazon.com/agreement/).

![AWS sign up website - contact details](https://github.com/practicalli/graphic-design/blob/live/cloud-services/aws/aws-sign-up-webpage-contact-information.png?raw=true)

Enter details of a valid credit/debit card.  AWS will charge $1 to the card, which will be returned in 3-5 days.

![AWS sign up - billing information](https://github.com/practicalli/graphic-design/blob/live/cloud-services/aws/aws-sign-up-webpage-billing-information.png?raw=true)

Confirm identity

> NOTE: do not include spaces in the security code even if they are in the image

Select **Send SMS**

![AWS sign up website - select confirm identity method](https://github.com/practicalli/graphic-design/blob/live/cloud-services/aws/aws-sign-up-webpage-confirm-identity.png?raw=true)


Confirm identity pin number

4 digit code (dont use the 5 digit phone number by mistake)

![AWS sign up website - confirm identity code](https://github.com/practicalli/graphic-design/blob/live/cloud-services/aws/aws-sign-up-webpage-confirm-identity-code.png?raw=true)

Select support plan - **Basic support - Free**

Select **Complete Sign up**

![AWS sign up website - select basic support plan](https://github.com/practicalli/graphic-design/blob/live/cloud-services/aws/aws-sign-up-webpage-support-plan-basic-free.png?raw=true)

Congratulations


An email will be sent to the root account address once the account is ready, which make take a few minutes.

Take a break from the form filling by stretching and taking some deep breaths.

![AWS sign up website - congratulations](https://github.com/practicalli/graphic-design/blob/live/cloud-services/aws/aws-sign-up-webpage-congratulations.png?raw=true)

!!! INFO "IAM Multi-Factor Authentication (MFA)"
    Visit the IAM dashboard and add Multi-Factor authentication (MFA) to the root user account for additional security.  Practicalli uses the [Authy app](https://authy.com/) for Multi-Factor authentication


## IAM User for Code & CLI

Login to AWS Management Console with root account

Search for and select IAM and create a new IAM user

![AWS IAM Users - create user](https://github.com/practicalli/graphic-design/blob/live/cloud-services/aws/web-console/amazon-aws-console-iam-user-create-1-user-details.png?raw=true)

Select **Add user to group**

Create new group and assing it to the user

![AWS IAM Users - select add user to group and create a new group](https://github.com/practicalli/graphic-design/blob/live/cloud-services/aws/web-console/amazon-aws-console-iam-user-create-user-group-added.png?raw=true)

The group should be assigned Permission policies to access the relevant AWS services, e.g. AwsS3FullAccess

![AWS IAM Users - assigning permissions policies to the new group](https://github.com/practicalli/graphic-design/blob/live/cloud-services/aws/web-console/amazon-aws-console-iam-user-create-user-group-with-permission-policies.png?raw=true)

Ensure the new user is added to the group (I missed this step out initially and access was not allowed)

![AWS IAM Users - view of new user account](https://github.com/practicalli/graphic-design/blob/live/cloud-services/aws/web-console/amazon-aws-console-iam-user-create-6-user-details-groups.png?raw=true)

Once the IAM user has been created, create an Access Key (key and secret)

Select the **Security credentials** tab in the user summary

Select **Command Line Interface (CLI)** and tick the check box to understand this isnt the recommended approach.

![AWS IAM Users - creating access key - selecting command line interface](https://github.com/practicalli/graphic-design/blob/live/cloud-services/aws/web-console/amazon-aws-console-iam-user-access-keys-cli-access.png?raw=true)

Retrieve the access key details so they can be used when configuring the AWS CLI tool.

![AWS IAM Users - retrieve access keys for created user](https://github.com/practicalli/graphic-design/blob/live/cloud-services/aws/web-console/amazon-aws-console-iam-user-access-keys-cli-access-retrieve-keys.png?raw=true)

> In a commercial environment, the operations team should create an IAM account for you, so this step is only relevant for your own education.


## Install AWS CLI 2

[AWS Command Line Interface (AWS CLI)](https://aws.amazon.com/cli/) is a unified tool to control multiple AWS services from the command line and automate them through scripts.

The AWS CLI configuration can also be used by Clojure code using the Cognitect Labs AWS API library.

Download the install script archive file

```shell
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
```

Extract the install script which extract to a directory called `aws`

```shell
unzip awscliv2.zip
```

Run the install script, providing the user password when prompted

```shell
sudo ~/aws/install
```

The install script can also be used to update an existing version of the AWS CLI version 2 (but not AWS CLI version 1)

```shell
sudo ~/aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update
```

## Configure AWS CLI

Use AWS CLI to create a configuration, using its wizard

```shell
aws configure
```

Enter the access key and access key secret from the IAM account when prompted

Enter the default region, e.g. eu-west-1 for Ireland

The wizard creates two files

- `~/.aws/config` containing the `default` profile
- `~/.aws/credentials` containing the AWS access key and secret (this is a plain text file, so not secure if someone hacks into your computer)

> An aws_session_token is not required, even though the AWS documentation mentions it repeatedly (but neglects to tell you how to create it)

## Install Clojure

[Practicalli guide to install Clojure CLI](https://practical.li/clojure/install/), Java and Practicalli Clojure CLI Config for a wide range of community tools.

> Leiningen should also work, although this tool was not tested

## Cognitect Labs AWS API's

Now for the easy part :)

[Create a new Clojure project](https://practical.li/clojure/clojure-cli/projects/), e.g. using the `:project/create` from Practicalli Clojure CLI

```shell
clojure -T:project/create :template app :name practicalli/bucket-of-data
```

Edit the `deps.edn` file and add the Cognitect Labs AWS API, Endpoints and S3 libraries

```clojure
  com.cognitect.aws/api {:mvn/version "0.8.666"}
  com.cognitect.aws/endpoints {:mvn/version "1.1.12.456"}
  com.cognitect.aws/s3 {:mvn/version "847.2.1365.0"}
```

> [latest-release.edn](https://github.com/cognitect-labs/aws-api/blob/main/latest-releases.edn) listed all the libraries and their current version

Start repl the repl, e.g. using the [Practicalli REPL Reloaded workflow](https://practical.li/clojure/clojure-cli/repl-reloaded/) or from an editor

```shell
clojure -M:repl/reloaded
```

Open `src/practicalli/bucket_of_data.clj` file in a Clojure aware editor & connect to the REPL process (if the editor was not used to start the REPL process)

Create a rich comment and start to experiment with the Cognitect Labs AWS API library.

Example creating an S3 bucket, adding a file and reading the contents of a file.

Require the main library

```clojure
(require '[cognitect.aws.client.api :as aws])
```

Define a client for the AWS S3 service

```clojure
(def data-bucket (aws/client {:api :s3}))
```

Validate requests to the S3 service to report incorrect arguments (especially useful when starting out with the library).  Underlying this is a Clojure specification derived from the AWS specifications.

```clojure
(aws/validate-requests data-bucket true)
```

Credentials are required for this request, so its a useful test to ensure the AWS CLI is configured correctly.

```clojure
(aws/invoke data-bucket {:op :ListBuckets})
```

> A REPL restart (stop/start) is required if the AWS environment variables are changed, otherwise the updated values in those environment variables will not be used.

As Cognitect Labs AWS API has a complete specification for each service, all the available operations for a specific service can be listed (even if the credentials are not working)

List the S3 Service operations.  Note, this returns a big data structure, so I find it useful to look at it in a data inspector, e.g. Portal, Cider Inspector or Morse

```clojure
(aws/ops data-bucket)
```

Once the name of the operation is know, view the documentation to see how it is used.

```clojure
(aws/doc data-bucket :CreateBucket)
```

![Clojure Cognitect Labs AWS API - navigate AWS S3 Bucket operations in Portal - create bucket](https://github.com/practicalli/graphic-design/blob/live/cloud-services/aws/clojure-aws-api-s3-operations-create-bucket.png?raw=true)

> The Practicalli REPL Reloaded workflow launches Portal at startup and all evaluations are sent to the Portal UI, so its easy to navigate the large list of operations for an AWS service.

## SSO Account approach

Single sign-on access can be used for engineers and command line access.

The recommended approach is to use the AWS IAM Identity Center as a Single Sign-On (SSO) service.  The IAM Identity Center can manage users and accounts in its own directory, useful for personal AWS accounts (and probably brand new startups too). The IAM Identity Center can use qn external identity provider instead, e.g. Okta, Google Workspace, Active Directory, etc.

An AWS Organisation is required to enable IAM Identity Center. It can take up to 24 hours for AWS to create an organisation if one does not already exist for the AWS account.

The IAM Identity Center approach will be covered in a future article.

## Summary

This is only the start of using AWS from Clojure and almost all the work was to simply configuring AWS itself.


There are lots of services to explore on AWS and with a working account and credentials and the excellent Cognitect Labs AWS API library it should be relatively straight forward (fingers crossed).

Please to keep a considered eye on how much of AWS you are using.  Even though a free plan was used, it can be quite easy to leave things running and exceed quotas.  Its not clear as yet if AWS will stop the service or simply send a bill.  Taking a look at the quotas allowed for a service is a valuable step to ensure you can remain within the free plan.

Thank you

[:fontawesome-brands-github: practicalli GitHub profile](https://github.com/practicalli) I [@practical_li](https://twitter.com/practcial_li)
