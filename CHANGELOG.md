# Changelog

## Unreleased

## 0.4.2

### New features

* New formatter: NullFormatter. Discards data without writing it anywhere.

## 0.4.1

### Bugs fixed

* [#58](https://github.com/mmozuras/pronto/pull/58): GitlabFormatter uses a high +per_page+ value to avoid pagination (and thus duplicate comments).

## 0.4.0

### New features

* Try to detect pull request id automatically, if `PULL_REQUEST_ID` is not specified. Inspired by @willnet/prid.
* [#40](https://github.com/mmozuras/pronto/issues/40): Add '--index' option for 'pronto run'. Pronto analyzes changes before committing.
* [#50](https://github.com/mmozuras/pronto/pull/50): Add GitLab formatter
* [#52](https://github.com/mmozuras/pronto/pull/52): Allow specifying a path for 'pronto run'.

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
* [#16](https://github.com/mmozuras/pronto/issues/16): New formatter: GithubPullRequestFormatter. Writes review comments on GitHub pull requests.

### Changes

* [#29](https://github.com/mmozuras/pronto/issues/29): Be compatible and depend on rugged '0.21.0'.
* Performance improvement: use Rugged::Blame instead of one provided by Grit.
* Performance improvement: cache comments retrieved from GitHub.
