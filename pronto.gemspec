# -*- encoding: utf-8 -*-
$LOAD_PATH.push File.expand_path('../lib', __FILE__)

require 'pronto/version'

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

  s.files = Dir.glob('{lib}/**/*') + %w(LICENSE README.md)
  s.test_files = `git ls-files -- {spec}/*`.split("\n")
  s.require_paths = ['lib']
  s.executables << 'pronto'

  s.add_runtime_dependency 'rugged', '~> 0.22.0'
  s.add_runtime_dependency 'thor', '~> 0.19.0'
  s.add_runtime_dependency 'octokit', '~> 3.8.0'
  s.add_runtime_dependency 'gitlab', '~> 3.4.0'
  s.add_development_dependency 'rake', '~> 10.4.0'
  s.add_development_dependency 'rspec', '~> 3.2.0'
  s.add_development_dependency 'rspec-its', '~> 1.2.0'
  s.add_development_dependency 'rspec-expectations', '~> 3.2.0'
end
