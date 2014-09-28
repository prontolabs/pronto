# Changelog

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
