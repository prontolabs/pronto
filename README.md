# Pronto

[![Code Climate](https://codeclimate.com/github/mmozuras/pronto.png)](https://codeclimate.com/github/mmozuras/pronto)
[![Build Status](https://secure.travis-ci.org/mmozuras/pronto.png)](http://travis-ci.org/mmozuras/pronto)
[![Gem Version](https://badge.fury.io/rb/pronto.png)](http://badge.fury.io/rb/pronto)
[![Dependency Status](https://gemnasium.com/mmozuras/pronto.png)](https://gemnasium.com/mmozuras/pronto)

Pronto runs analysis quickly by checking only the relevant changes. Created to
be used on pull requests, but suited for other scenarios as well. Perfect if you
want to find out quickly if branch introduces changes that conform to your
[styleguide](https://github.com/mmozuras/pronto-rubocop), [are DRY](https://github.com/mmozuras/pronto-flay), [don't introduce security holes](https://github.com/mmozuras/pronto-brakeman) and [more](#runners).

![Pronto demo](pronto.gif "")

## Usage

### Pull Requests

You can run Pronto as part of your builds and then get results as comments
using `GithubFormatter`.

Add Pronto runners you want to use to your Gemfile:
```ruby
  gem 'pronto-rubocop'
```
or gemspec file:
```ruby
  s.add_development_dependency 'pronto-rubocop'
```
Set environment variable GITHUB_ACCESS_TOKEN to OAuth token that has access to
repository. Then set it up to run using the included rake task or manually:
```ruby
  Pronto.gem_names.each { |gem_name| require "pronto/#{gem_name}" }

  formatter = Pronto::Formatter::GithubFormatter.new
  Pronto.run('origin/master', '.', formatter)
```

### Local Changes

You can run Pronto locally. First, install Pronto and runners you want to use:
```bash
  gem install pronto
  gem install pronto-rubocop
```
Then navigate to repository you want run Pronto on, and:
```bash
  git checkout feature/branch
  pronto run # Pronto runs against master by default
```

Run `pronto` in your terminal without any arguments to see what more Pronto is
capable off.

## Runners

Pronto can run various tools and libraries, as long as there's a runner for it.
Currently available runners:

* [pronto-rubocop](https://github.com/mmozuras/pronto-rubocop)
* [pronto-flay](https://github.com/mmozuras/pronto-flay)
* [pronto-brakeman](https://github.com/mmozuras/pronto-brakeman)
* [pronto-rails_best_practices](https://github.com/mmozuras/pronto-rails_best_practices)
* [pronto-reek](https://github.com/mmozuras/pronto-reek)
* [pronto-poper](https://github.com/mmozuras/pronto-poper)
* [pronto-jshint](https://github.com/mmozuras/pronto-jshint)
* [pronto-spell](https://github.com/mmozuras/pronto-spell)
