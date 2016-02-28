require 'rugged'
require 'octokit'
require 'gitlab'
require 'forwardable'

require 'pronto/gem_names'

require 'pronto/logger'
require 'pronto/config_file'
require 'pronto/config'

require 'pronto/git/repository'
require 'pronto/git/patches'
require 'pronto/git/patch'
require 'pronto/git/line'

require 'pronto/plugin'
require 'pronto/message'
require 'pronto/runner'
require 'pronto/runners'
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

    result = Runners.new.run(patches)

    formatted = formatter.format(result, repo, patches)
    puts formatted if formatted

    result
  end
end
