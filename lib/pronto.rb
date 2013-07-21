require 'grit-ext'
require 'pronto/plugin'
require 'pronto/message'
require 'pronto/runner'

module Pronto
  def self.run(start_commit, end_commit = 'master', repo_path = '/')
    repo = Grit::Repo.new(repo_path)
    diffs = repo.diff(start_commit, end_commit)

    Runner.runners.map do |runner|
      runner.new.run(diffs)
    end.flatten.compact
  end
end
