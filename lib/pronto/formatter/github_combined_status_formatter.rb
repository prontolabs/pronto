require_relative 'github_status_formatter/status_builder'

module Pronto
  module Formatter
    class GithubCombinedStatusFormatter
      def format(messages, repo, _)
        client = Github.new(repo)
        head = repo.head_commit_sha

        create_status(client, head, messages.uniq || [])
      end

      private

      def create_status(client, sha, messages)
        builder = GithubStatusFormatter::StatusBuilder.new(nil, messages)
        status = Status.new(sha, builder.state,
                            'pronto', builder.description)

        client.create_commit_status(status)
      end
    end
  end
end
