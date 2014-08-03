require 'rugged'
require 'forwardable'

require 'pronto/git/repository'
require 'pronto/git/patches'
require 'pronto/git/patch'
require 'pronto/git/line'
require 'pronto/git/remote'

require 'pronto/plugin'
require 'pronto/message'
require 'pronto/runner'

require 'pronto/formatter/text_formatter'
require 'pronto/formatter/json_formatter'
require 'pronto/formatter/github_formatter'
require 'pronto/formatter/checkstyle_formatter'
require 'pronto/formatter/formatter'

module Pronto
  def self.run(commit = 'master', repo_path = '.', formatter = nil)
    commit ||= 'master'

    repo = Git::Repository.new(repo_path)
    patches = repo.diff(commit)

    result = run_all_runners(patches)

    formatter ||= default_formatter
    formatter.format(result, repo)
  end

  def self.gem_names
    gems = Gem::Specification.find_all.select do |gem|
      if gem.name =~ /^pronto-/
        true
      elsif gem.name != 'pronto'
        runner_path = File.join(gem.full_gem_path, "lib/pronto/#{gem.name}.rb")
        File.exist?(runner_path)
      end
    end

    gems.map { |gem| gem.name.sub(/^pronto-/, '') }
        .uniq
        .sort
  end

  private

  def self.run_all_runners(patches)
    Runner.runners.map do |runner|
      runner.new.run(patches, patches.commit)
    end.flatten.compact
  end

  def default_formatter
    Formatter::TextFormatter.new
  end
end
