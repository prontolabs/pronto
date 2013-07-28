require 'grit-ext'

require 'pronto/plugin'
require 'pronto/message'
require 'pronto/runner'

require 'pronto/formatter/text_formatter'

module Pronto
  def self.run(start_commit, end_commit = 'master', repo_path = '/')
    repo = Grit::Repo.new(repo_path)
    diffs = repo.diff(start_commit, end_commit)
    result = run_all_runners(diffs)
    Formatter::TextFormatter.new.format(result)
  end

  def self.run_all_runners(diffs)
    Runner.runners.map do |runner|
      runner.new.run(diffs)
    end.flatten.compact
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
end
