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
end
