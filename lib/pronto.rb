require 'rugged'
require 'octokit'
require 'gitlab'
require 'forwardable'

require 'pronto/git/repository'
require 'pronto/git/patches'
require 'pronto/git/patch'
require 'pronto/git/line'

require 'pronto/plugin'
require 'pronto/message'
require 'pronto/runner'
require 'pronto/github'
require 'pronto/gitlab'

require 'pronto/formatter/text_formatter'
require 'pronto/formatter/json_formatter'
require 'pronto/formatter/github_formatter'
require 'pronto/formatter/github_pull_request_formatter'
require 'pronto/formatter/gitlab_formatter'
require 'pronto/formatter/checkstyle_formatter'
require 'pronto/formatter/null_formatter'
require 'pronto/formatter/formatter'

module Pronto
  def self.run(commit = 'master', repo_path = '.',
               formatter = Formatter::TextFormatter.new, file = nil)
    commit ||= 'master'

    repo = Git::Repository.new(repo_path)
    options = { paths: [file] } if file
    patches = repo.diff(commit, options)

    result = run_all_runners(patches)

    formatted = formatter.format(result, repo, patches)
    puts formatted if formatted

    result
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
end
