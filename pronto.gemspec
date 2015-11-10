# -*- encoding: utf-8 -*-

$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'pronto/version'
require 'English'

Gem::Specification.new do |s|
  s.name = 'pronto'
  s.version = Pronto::VERSION
  s.platform = Gem::Platform::RUBY
  s.author = 'Mindaugas Mozūras'
  s.email = 'mindaugas.mozuras@gmail.com'
  s.homepage = 'http://github.com/mmozuras/pronto'
  s.summary = 'Pronto runs analysis by checking only the introduced changes'
  s.description = <<-EOF
    Pronto runs analysis quickly by checking only the relevant changes. Created
    to be used on pull requests, but suited for other scenarios as well. Perfect
    if you want to find out quickly if branch introduces changes that conform to
    your styleguide, are DRY, don't introduce security holes and more.
  EOF

  s.required_rubygems_version = '>= 1.3.6'
  s.license = 'MIT'

  s.files = `git ls-files`.split($RS).reject do |file|
    file =~ %r{^(?:
    spec/.*
    |Gemfile
    |Rakefile
    |\.rspec
    |\.gitignore
    |\.rubocop.yml
    |\.travis.yml
    )$}x
  end
  s.test_files = []
  s.extra_rdoc_files = ['LICENSE', 'README.md']
  s.require_paths = ['lib']
  s.executables = s.files.grep(%r{^bin/}) { |f| File.basename(f) }

  s.add_runtime_dependency('rugged', '~> 0.23.0')
  s.add_runtime_dependency('thor', '~> 0.19.0')
  s.add_runtime_dependency('octokit', '~> 4.1.0')
  s.add_runtime_dependency('gitlab', '~> 3.4.0')
  s.add_development_dependency('rake', '~> 10.4.0')
  s.add_development_dependency('rspec', '~> 3.3.0')
  s.add_development_dependency('rspec-its', '~> 1.2.0')
  s.add_development_dependency('rspec-expectations', '~> 3.3.0')
  s.add_development_dependency('bundler', '~> 1.3')
  s.add_development_dependency('simplecov', '~> 0.10')
end
