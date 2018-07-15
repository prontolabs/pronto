# -*- encoding: utf-8 -*-

$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'pronto/version'
require 'English'

Gem::Specification.new do |s|
  s.name = 'pronto'
  s.version = Pronto::Version::STRING
  s.platform = Gem::Platform::RUBY
  s.author = 'Mindaugas Mozūras'
  s.email = 'mindaugas.mozuras@gmail.com'
  s.homepage = 'https://github.com/prontolabs/pronto'
  s.summary = 'Pronto runs analysis by checking only the introduced changes'
  s.description = <<-EOF
    Pronto runs analysis quickly by checking only the relevant changes. Created
    to be used on pull requests, but suited for other scenarios as well. Perfect
    if you want to find out quickly if branch introduces changes that conform to
    your styleguide, are DRY, don't introduce security holes and more.
  EOF

  s.licenses = ['MIT']
  s.required_ruby_version = '>= 2.0.0'
  s.rubygems_version = '1.8.23'

  s.files = `git ls-files`.split($RS).reject do |file|
    file =~ %r{^(?:
    spec/.*
    |Gemfile
    |Rakefile
    |pronto.gif
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

  s.add_runtime_dependency('rugged', '~> 0.24', '>= 0.23.0')
  s.add_runtime_dependency('thor', '~> 0.20.0')
  s.add_runtime_dependency('octokit', '~> 4.7', '>= 4.7.0')
  s.add_runtime_dependency('gitlab', '~> 4.0', '>= 4.0.0')
  s.add_runtime_dependency('httparty', '>= 0.13.7')
  s.add_runtime_dependency('rainbow', '>= 2.2', '< 4.0')
  s.add_development_dependency('rake', '~> 12.0')
  s.add_development_dependency('rspec', '~> 3.4')
  s.add_development_dependency('rspec-its', '~> 1.2')
  s.add_development_dependency('rspec-expectations', '~> 3.4')
  s.add_development_dependency('bundler', '~> 1.3')
  s.add_development_dependency('simplecov', '~> 0.14')
  s.add_development_dependency('rubocop', '~> 0.58')
  s.add_development_dependency('pronto-rubocop', '~> 0.9.0')
  s.add_development_dependency('codeclimate-test-reporter', '~> 1.0')
end
