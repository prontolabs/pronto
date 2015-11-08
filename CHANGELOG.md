# Changelog

## Unreleased

### New features

* [#104](https://github.com/mmozuras/pronto/pull/104): configure via .pronto.yml file.
* [#86](https://github.com/mmozuras/pronto/pull/86): ability to specify GitHub slug via configuration or environment variable.
* [#77](https://github.com/mmozuras/pronto/pull/77): ability to specify GitHub endpoints via configuration or environment variable.

### Changes

* [#82](https://github.com/mmozuras/pronto/pull/82): treat Rake files as Ruby files.
* [#107](https://github.com/mmozuras/pronto/pull/107): use desc: instead of banner: for CLI options descriptions.


### Bugs fixed

* [#87](https://github.com/mmozuras/pronto/pull/87): handle github remote urls without .git suffix.
* [#91](https://github.com/mmozuras/pronto/pull/91): find position in full diff and fix how commit id is used in GithubPullRequestFormatter.
* [#92](https://github.com/mmozuras/pronto/pull/92): ignore failed pull request comments.
* [#93](https://github.com/mmozuras/pronto/pull/93): comments didn't have position when outdated.
* [#94](https://github.com/mmozuras/pronto/pull/94): duplicate comment detection was failing for large GitHub pull requests.
* [poper#4](https://github.com/mmozuras/pronto-poper/issues/4): handle message uniqueness when they're without line numbers.
* [#101](https://github.com/mmozuras/pronto/pull/101): make GitLab work with ssh port urls.

## 0.4.3

### Changes

* Depend on `rugged ~> 0.23.0` and `octokit ~> 4.1.0`.

## 0.4.2

### New features

* New formatter: NullFormatter. Discards data without writing it anywhere.

## 0.4.1

### Bugs fixed

* [#58](https://github.com/mmozuras/pronto/pull/58): GitlabFormatter uses a high +per_page+ value to avoid pagination (and thus duplicate comments).

## 0.4.0

### New features

* Try to detect pull request id automatically, if `PULL_REQUEST_ID` is not specified. Inspired by @willnet/prid.
* [#40](https://github.com/mmozuras/pronto/issues/40): add '--index' option for 'pronto run'. Pronto analyzes changes before committing.
* [#50](https://github.com/mmozuras/pronto/pull/50): add GitLab formatter
* [#52](https://github.com/mmozuras/pronto/pull/52): allow specifying a path for 'pronto run'.

### Changes

* GitHub and GitHub pull request formatters now filter out duplicate offenses on the same line to avoid spamming with redundant comments.

## 0.3.3

### Bugs fixed

* GithubPullRequestFormatter was working incorrectly with merge commits.

## 0.3.2

### Bugs fixed

* GithubPullRequestFormatter had an off-by-one positioning error.

## 0.3.1

### Bugs fixed

* Git::Patches#repo was always returning nil.

## 0.3.0

### New features

* [#27](https://github.com/mmozuras/pronto/issues/27): '--exit-code' option for 'pronto run'. Pronto exits with non-zero code if there were any warnings/errors.
* [#16](https://github.com/mmozuras/pronto/issues/16): new formatter: GithubPullRequestFormatter. Writes review comments on GitHub pull requests.

### Changes

* [#29](https://github.com/mmozuras/pronto/issues/29): be compatible and depend on rugged '0.21.0'.
* Performance improvement: use Rugged::Blame instead of one provided by Grit.
* Performance improvement: cache comments retrieved from GitHub.
