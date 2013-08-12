require 'rugged'

require 'pronto/plugin'
require 'pronto/message'
require 'pronto/runner'

require 'pronto/formatter/text_formatter'

module Pronto
  def self.run(commit1 = nil, commit2 = 'master', repo_path = '.')
    diffs = diff(repo_path, commit1, commit2)
    result = run_all_runners(diffs)
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

  def self.diff(repo_path, commit1, commit2)
    repo = Rugged::Repository.new(repo_path)
    commit1 ||= repo.head.target
    commit2 ||= 'master'
    repo.diff(commit1, commit2)
  end

  def self.run_all_runners(diffs)
    Runner.runners.map do |runner|
      runner.new.run(diffs)
    end.flatten.compact
  end
end
