require 'rugged'
require_relative 'rugged/diff'
require_relative 'rugged/tree'
require_relative 'rugged/diff/delta'
require_relative 'rugged/diff/patch'
require_relative 'rugged/diff/line'

require 'pronto/plugin'
require 'pronto/message'
require 'pronto/runner'

require 'pronto/formatter/text_formatter'

module Pronto
  def self.run(commit = 'master', repo_path = '.')
    patches = diff(repo_path, commit)
    result = run_all_runners(patches)
    Formatter::TextFormatter.new.format(result)
  end

  def self.gem_names
    gems = Gem::Specification.find_all.select do |gem|
      if gem.name =~ /^pronto-/
        true
      elsif gem.name != 'pronto'
        runner_path = File.join(gem.full_gem_path, "lib/pronto/#{gem.name}.rb")
        File.exists?(runner_path)
      end
    end

    gems.map { |gem| gem.name.sub(/^pronto-/, '') }
        .uniq
        .sort
  end

  private

  def self.diff(repo_path, commit)
    repo = Rugged::Repository.new(repo_path)
    commit ||= 'master'
    repo.diff(commit, repo.head.target)
  end

  def self.run_all_runners(patches)
    Runner.runners.map do |runner|
      runner.new.run(patches)
    end.flatten.compact
  end
end
