# Pronto

[![Code Climate](https://codeclimate.com/github/mmozuras/pronto.png)](https://codeclimate.com/github/mmozuras/pronto)
[![Build Status](https://secure.travis-ci.org/mmozuras/pronto.png)](http://travis-ci.org/mmozuras/pronto)
[![Gem Version](https://badge.fury.io/rb/pronto.png)](http://badge.fury.io/rb/pronto)
[![Dependency Status](https://gemnasium.com/mmozuras/pronto.png)](https://gemnasium.com/mmozuras/pronto)
[![Inline docs](http://inch-ci.org/github/mmozuras/pronto.png)](http://inch-ci.org/github/mmozuras/pronto)

Pronto runs analysis quickly by checking only the relevant changes. Created to
be used on [pull requests](#github-integration), but also works [locally](#local-changes) and integrates with [GitLab](#gitlab-integration).
Perfect if want to find out quickly if branch introduces changes that conform
to your [styleguide](https://github.com/mmozuras/pronto-rubocop), [are DRY](https://github.com/mmozuras/pronto-flay), [don't introduce security holes](https://github.com/mmozuras/pronto-brakeman) and [more](#runners).

![Pronto demo](pronto.gif "")

## Usage

Pronto runs the checks on a diff between the current HEAD and the provided commit-ish (default is master).

### GitHub Integration

You can run Pronto as a step of your CI builds and get the results as comments
on GitHub commits using `GithubFormatter` or `GithubPullRequestFormatter`.

Add Pronto runners you want to use to your Gemfile:
```ruby
gem 'pronto'
gem 'pronto-rubocop', require: false
gem 'pronto-scss', require: false
```
or gemspec file:
```ruby
s.add_development_dependency 'pronto'
s.add_development_dependency 'pronto-rubocop'
s.add_development_dependency 'pronto-scss'
```
Set the GITHUB_ACCESS_TOKEN environment variable to [OAuth token](https://help.github.com/articles/creating-an-access-token-for-command-line-use)
that has access to the repository.

Then just run it:
```bash
GITHUB_ACCESS_TOKEN=token pronto run -f github -c origin/master
```
or, if you want comments to appear on pull request diff, instead of commit:
```bash
GITHUB_ACCESS_TOKEN=token PULL_REQUEST_ID=id pronto run -f github_pr -c origin/master
```

As an alternative, you can also set up a rake task:
```ruby
Pronto.gem_names.each { |gem_name| require "pronto/#{gem_name}" }

formatter = Pronto::Formatter::GithubFormatter.new # or GithubPullRequestFormatter
Pronto.run('origin/master', '.', formatter)
```

### GitLab Integration

You can run Pronto as a step of your CI builds and get the results as comments
on GitLab commits using `GitlabFormatter`.

**note: this requires at least GitLab v7.5.0**

Add Pronto runners you want to use to your Gemfile:
```ruby
gem 'pronto'
gem 'pronto-rubocop', require: false
gem 'pronto-scss', require: false
```
or gemspec file:
```ruby
s.add_development_dependency 'pronto'
s.add_development_dependency 'pronto-rubocop'
s.add_development_dependency 'pronto-scss'
```

Set the `GITLAB_API_ENDPOINT` environment variable to your API endpoint URL.
If you are using Gitlab.com's hosted service your endpoint will be `https://gitlab.com/api/v3`.
Set the `GITLAB_API_PRIVATE_TOKEN` environment variable to your Gitlab private token
which you can find in your account settings.

Then just run it:
```bash
GITLAB_API_ENDPOINT="https://gitlab.com/api/v3" GITLAB_API_PRIVATE_TOKEN=token pronto run -f gitlab -c origin/master
```

As an alternative, you can also set up a rake task:
```ruby
Pronto.gem_names.each { |gem_name| require "pronto/#{gem_name}" }

formatter = Pronto::Formatter::GitlabFormatter.new
Pronto.run('origin/master', '.', formatter)
```

### Local Changes

You can run Pronto locally. First, install Pronto and the runners you want to use:
```bash
gem install pronto
gem install pronto-rubocop
```
Then navigate to the repository you want to run Pronto on, and:
```bash
git checkout feature/branch
pronto run # Pronto runs against master by default
```

Just run `pronto` without any arguments to see what Pronto is capable of.

## Runners

Pronto can run various tools and libraries, as long as there's a runner for it.
Currently available:

* [pronto-brakeman](https://github.com/mmozuras/pronto-brakeman)
* [pronto-coffeelint](https://github.com/siebertm/pronto-coffeelint)
* [pronto-flay](https://github.com/mmozuras/pronto-flay)
* [pronto-foodcritic](https://github.com/mmozuras/pronto-foodcritic)
* [pronto-jshint](https://github.com/mmozuras/pronto-jshint)
* [pronto-haml](https://github.com/mmozuras/pronto-haml)
* [pronto-poper](https://github.com/mmozuras/pronto-poper)
* [pronto-rails_best_practices](https://github.com/mmozuras/pronto-rails_best_practices)
* [pronto-reek](https://github.com/mmozuras/pronto-reek)
* [pronto-rubocop](https://github.com/mmozuras/pronto-rubocop)
* [pronto-scss](https://github.com/mmozuras/pronto-scss)
* [pronto-spell](https://github.com/mmozuras/pronto-spell)
