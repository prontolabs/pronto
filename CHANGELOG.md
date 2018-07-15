# Changelog

## Unreleased

### Bugs fixed

* [#258](https://github.com/prontolabs/pronto/pull/258): fix blame returning nil when file does not exist in the git tree.
* [#270](https://github.com/prontolabs/pronto/pull/270): fix ${line} in text format to mean line number.
* [#282](https://github.com/prontolabs/pronto/issues/282): relax rainbow dependency.

### Changes

* Depend on thor `0.20.*`.
* [#298](https://github.com/prontolabs/pronto/pull/298): change default GitLab API endpoint to v4.

## 0.9.5

### Bugs fixed

* [#253](https://github.com/prontolabs/pronto/pull/253): fix an infinite loop when Bitbucket Server sends a paginated response.

### Changes

* [#250](https://github.com/prontolabs/pronto/issues/250): allow HTTParty `0.15.*`.

## 0.9.4

### Changes

* [#227](https://github.com/prontolabs/pronto/issues/227): the repository was converted from an individual one (mmozuras/pronto) to an org (prontolabs/pronto).
* [#247](https://github.com/prontolabs/pronto/pull/247): try to find GitHub pull request by sha when HEAD is detached.

### Bugs fixed

* [#235](https://github.com/prontolabs/pronto/pull/235): do not submit empty pull request reviews to GitHub.

## 0.9.3

### Bugs fixed

* [#234](https://github.com/prontolabs/pronto/pull/234): text formatter was not working, require delegate.rb in text_message_decorator.rb to fix.

## 0.9.2

### Bugs fixed

* [#231](https://github.com/prontolabs/pronto/pull/231): GitHub pull request review formatter was not working in some cases without Accept header.

## 0.9.1

### Bugs fixed

* Poper and some other runners were not working correctly. When using staged/unstaged flags, pass a string instead of Rugged::Commit as commit parameter for runners.

## 0.9.0

### New features

* [#206](https://github.com/prontolabs/pronto/pull/216): add Bitbucket Server pull request formatter.
* [#204](https://github.com/prontolabs/pronto/pull/204): add ability configure message format for each formatter.
* [#111](https://github.com/prontolabs/pronto/issues/111): add `--staged` option for `pronto run` to analyze staged changes.
* [#217](https://github.com/prontolabs/pronto/issues/217): add GitHub pull request review formatter.

### Changes

* [#193](https://github.com/prontolabs/pronto/issues/193): rename `pronto run --index` option to `--unstaged`.
* [#49](https://github.com/prontolabs/pronto/issues/49): handle nonexistence of GitHub pull requests gracefully.
* [#217](https://github.com/prontolabs/pronto/issues/217): depend on `octokit >= 4.7.0`.
* [#224](https://github.com/prontolabs/pronto/issues/224): depend on `gitlab >= 4.0.0`.
* [#222](https://github.com/prontolabs/pronto/pull/184): prefix PULL_REQUEST_ID env variable with `PRONTO_`.

### Bugs fixed

* [#215](https://github.com/prontolabs/pronto/pull/215): an exclusion of files for single runner led to those files being excluded for all runners.

## 0.8.2

### Bugs fixed

* [#203](https://github.com/prontolabs/pronto/pull/203): fix unintentional class conversion that led to exclude config option not working.

## 0.8.1

### Changes

* Add a default GitLab API endpoint: https://gitlab.com/api/v3.

### Bugs fixed

* [#125](https://github.com/prontolabs/pronto/issues/125): check whether message has a line before posting to GitLab.
* Post on commit comments on correct commit: use message.commit_sha to set comment.sha instead of head.
* [#201](https://github.com/prontolabs/pronto/issues/201): allow messages without line positions or paths.

## 0.8.0

### New features

* [#199](https://github.com/prontolabs/pronto/pull/199): add support for Ruby 2.4.0.

### Changes

* [#181](https://github.com/prontolabs/pronto/pull/181): add ENV variables for all configuration options.
* [#184](https://github.com/prontolabs/pronto/pull/184): prefix all ENV variables with `PRONTO_`.
* [#185](https://github.com/prontolabs/pronto/pull/185): allow excluding files to lint for single runner.

### Bugs fixed

* [#179](https://github.com/prontolabs/pronto/pull/179): correctly select branch name for fix Bitbucket pull request formatter.
* [#187](https://github.com/prontolabs/pronto/pull/187): correctly handle nil/false with consolidate_comments config option.
* [#189](https://github.com/prontolabs/pronto/pull/189): do not post anything when all consolidated comments already exist.
* [#195](https://github.com/prontolabs/pronto/pull/195): fix warning for default formatters value.

## 0.7.1

### Changes

* Remove support for Ruby 1.9.3.

### Bugs fixed

* [#149](https://github.com/prontolabs/pronto/issues/149): use patches to correctly find line position for GitHub pull request formatter.

## 0.7.0

### New features

* [#135](https://github.com/prontolabs/pronto/pull/135): add Bitbucket formatter.
* [#135](https://github.com/prontolabs/pronto/pull/135): add Bitbucket pull request formatter.
* [#134](https://github.com/prontolabs/pronto/pull/134): colorize text formatter.
* [#144](https://github.com/prontolabs/pronto/pull/144): add GitHub status formatter.
* [#157](https://github.com/prontolabs/pronto/pull/157): ability to run pronto CLI from within subdirectories of a git repository.
* [#154](https://github.com/prontolabs/pronto/pull/154): add an option to consolidate pull request comments.

### Changes

* [#162](https://github.com/prontolabs/pronto/pull/162): don't count info messages for error exit code.

### Bugs fixed

* [#153](https://github.com/prontolabs/pronto/pull/153): correctly get repo_path.

## 0.6.0

### New features

* Add `-V/--verbose-version` option that displays Ruby version.
* [#127](https://github.com/prontolabs/pronto/pull/127): ability to specify `max_warnings` via configuration or environment variable.
* [#18](https://github.com/prontolabs/pronto/issues/18): ability to specify `verbose` via configuration, which can provide more output for debugging purposes.
* [#83](https://github.com/prontolabs/pronto/issues/83): support multiple formatters as an option to `pronto run`.

### Changes

* `--version` only displays the version itself without any additional text.
* Replace `Pronto.gem_names` with `Pronto::GemNames.new.to_a`.
* [#116](https://github.com/prontolabs/pronto/pull/116): improve GitHub formatter error output.
* [#123](https://github.com/prontolabs/pronto/pull/126): add runner attribute to message initialization.
* Runner expects to receive patches/commit via `initialize(patches, commit)`, instead of `run(patches, commit)`.

### Bugs fixed

* [#122](https://github.com/prontolabs/pronto/pull/122): ignore symlink directories.

## 0.5.3

### Bugs fixed

* Remove pronto.gif from gem, accidently included since `0.5.0`.

## 0.5.2

### Bugs fixed

* GithubPullRequestFormatter was working incorrectly when `PULL_REQUEST_ID` is not specified. Introduced in `0.5.1`.

## 0.5.1

### Changes

* Try to retrieve commit sha for GitHub PR via GitHub API instead of trusting local sha.

## 0.5.0

### New features

* [#104](https://github.com/prontolabs/pronto/pull/104): configure via .pronto.yml file.
* [#86](https://github.com/prontolabs/pronto/pull/86): ability to specify GitHub slug via configuration or environment variable.
* [#77](https://github.com/prontolabs/pronto/pull/77): ability to specify GitHub endpoints via configuration or environment variable.
* [#108](https://github.com/prontolabs/pronto/pull/108): ability to specify excluded files via configuration.

### Changes

* [#82](https://github.com/prontolabs/pronto/pull/82): treat Rake files as Ruby files.
* [#107](https://github.com/prontolabs/pronto/pull/107): use desc: instead of banner: for CLI options descriptions.

### Bugs fixed

* [#87](https://github.com/prontolabs/pronto/pull/87): handle github remote urls without .git suffix.
* [#91](https://github.com/prontolabs/pronto/pull/91): find position in full diff and fix how commit id is used in GithubPullRequestFormatter.
* [#92](https://github.com/prontolabs/pronto/pull/92): ignore failed pull request comments.
* [#93](https://github.com/prontolabs/pronto/pull/93): comments didn't have position when outdated.
* [#94](https://github.com/prontolabs/pronto/pull/94): duplicate comment detection was failing for large GitHub pull requests.
* [poper#4](https://github.com/prontolabs/pronto-poper/issues/4): handle message uniqueness when they're without line numbers.
* [#101](https://github.com/prontolabs/pronto/pull/101): make GitLab work with ssh port urls.

## 0.4.3

### Changes

* Depend on `rugged ~> 0.23.0` and `octokit ~> 4.1.0`.

## 0.4.2

### New features

* New formatter: NullFormatter. Discards data without writing it anywhere.

## 0.4.1

### Bugs fixed

* [#58](https://github.com/prontolabs/pronto/pull/58): GitlabFormatter uses a high +per_page+ value to avoid pagination (and thus duplicate comments).

## 0.4.0

### New features

* Try to detect pull request id automatically, if `PULL_REQUEST_ID` is not specified. Inspired by @willnet/prid.
* [#40](https://github.com/prontolabs/pronto/issues/40): add '--index' option for 'pronto run'. Pronto analyzes changes before committing.
* [#50](https://github.com/prontolabs/pronto/pull/50): add GitLab formatter
* [#52](https://github.com/prontolabs/pronto/pull/52): allow specifying a path for 'pronto run'.

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

* [#27](https://github.com/prontolabs/pronto/issues/27): '--exit-code' option for 'pronto run'. Pronto exits with non-zero code if there were any warnings/errors.
* [#16](https://github.com/prontolabs/pronto/issues/16): new formatter: GithubPullRequestFormatter. Writes review comments on GitHub pull requests.

### Changes

* [#29](https://github.com/prontolabs/pronto/issues/29): be compatible and depend on rugged '0.21.0'.
* Performance improvement: use Rugged::Blame instead of one provided by Grit.
* Performance improvement: cache comments retrieved from GitHub.
