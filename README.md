# pronto

[![Code Climate](https://codeclimate.com/github/mmozuras/pronto.png)](https://codeclimate.com/github/mmozuras/pronto)
[![Build Status](https://secure.travis-ci.org/mmozuras/pronto.png)](http://travis-ci.org/mmozuras/pronto)
[![Gem Version](https://badge.fury.io/rb/pronto.png)](http://badge.fury.io/rb/pronto)
[![Dependency Status](https://gemnasium.com/mmozuras/pronto.png)](https://gemnasium.com/mmozuras/pronto)

## Usage

Pronto runs analysis quickly by checking only the introduced changes. Created
to be used on pull requets, but suited for other scenarios as well.

![Pronto demo](pronto.gif "")

### Pull Requests

You can run Pronto as part of your builds and then get results as comments
using `GithubFormatter`.

Actually, Pronto runs Pronto whenever you make a pull request on Pronto. It
uses Travis CI and the included `TravisPullRequest` rake task for that.

To do the same, start by adding Pronto runners you want to use to your Gemfile:
```ruby
  gem 'pronto-rubocop'
```
or gemspec file:
```ruby
  s.add_development_dependency 'pronto-rubocop'
```
Then run it using the included rake task or manually.

### Local Changes

You can run Pronto locally. First, install Pronto and runners you want to use:
```bash
  gem install pronto
  gem install pronto-rubocop
```
Then navigate to repository you want run Pronto on, and:
```bash
  git checkout feature/branch
  pronto exec # Pronto runs against master by default
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
* [pronto-poper](https://github.com/mmozuras/pronto-poper)
