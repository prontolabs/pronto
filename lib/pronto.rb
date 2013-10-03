require 'rugged'
require_relative 'rugged/diff'
require_relative 'rugged/diff/delta'
require_relative 'rugged/diff/patch'
require_relative 'rugged/diff/line'
require_relative 'rugged/tree'
require_relative 'rugged/remote'

require 'pronto/plugin'
require 'pronto/message'
require 'pronto/runner'

require 'pronto/formatter/text_formatter'
require 'pronto/formatter/json_formatter'
require 'pronto/formatter/github_formatter'
require 'pronto/formatter/formatter'

module Pronto
  def self.run(commit = 'master', repo_path = '.', formatter = nil)
    patches = diff(repo_path, commit)
    result = run_all_runners(patches)

    formatter ||= default_formatter
    formatter.format(result)
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

  def default_formatter
    Formatter::TextFormatter.new
  end
end
