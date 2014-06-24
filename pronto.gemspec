# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)

require 'pronto/version'

Gem::Specification.new do |s|
  s.name        = 'pronto'
  s.version     = Pronto::VERSION
  s.platform    = Gem::Platform::RUBY
  s.author      = 'Mindaugas Mozūras'
  s.email       = 'mindaugas.mozuras@gmail.com'
  s.homepage    = 'http://github.org/mmozuras/pronto'
  s.summary     = 'Pronto runs analysis quickly by checking only the introduced changes'

  s.required_rubygems_version = '>= 1.3.6'
  s.license = 'MIT'

  s.files         = Dir.glob('{lib}/**/*') + %w[LICENSE README.md]
  s.test_files    = `git ls-files -- {spec}/*`.split("\n")
  s.require_paths = ['lib']
  s.executables << 'pronto'

  s.add_runtime_dependency 'rugged', '~> 0.19', '>= 0.19.0'
  s.add_runtime_dependency 'thor', '~> 0.19', '>= 0.19.1'
  s.add_runtime_dependency 'octokit', '~> 2.7', '>= 2.7.1'
  s.add_runtime_dependency 'grit', '~> 2.5', '>= 2.5.0'
  s.add_development_dependency 'rake', '~> 10.1', '>= 10.1.0'
  s.add_development_dependency 'rspec', '~> 2.14', '>= 2.14.0'
end
