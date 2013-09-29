# pronto

[![Code Climate](https://codeclimate.com/github/mmozuras/pronto.png)](https://codeclimate.com/github/mmozuras/pronto)
[![Build Status](https://secure.travis-ci.org/mmozuras/pronto.png)](http://travis-ci.org/mmozuras/pronto)
[![Dependency Status](https://gemnasium.com/mmozuras/pronto.png)](https://gemnasium.com/mmozuras/pronto)

## Usage

Pronto runs analysis quickly by checking only the introduced changes.

### Pull Requests

You can run Pronto as part of your builds and then get results as commit
comments using `GithubFormatter`.

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

You can run Pronto locally. First, install Pronto andrunners you want to use:
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
