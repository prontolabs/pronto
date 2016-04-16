require_relative 'github_status_formatter/status_builder'

module Pronto
  module Formatter
    class GithubStatusFormatter
      def initialize(opts = {})
        @level_mapping ||= opts.fetch(:level_mapping, {})
      end

      def format(messages, repo, _)
        client = Github.new(repo)
        head = repo.head_commit_sha

        messages_by_runner = messages.uniq.group_by(&:runner)

        Runner.runners.each do |runner|
          create_status(client, head, runner, messages_by_runner[runner] || [])
        end
      end

      private

      def create_status(client, sha, runner, messages)
        builder = StatusBuilder.new(messages, @level_mapping.fetch(runner, {}))
        status = Github::Status.new(sha, builder.state, runner.name, builder.description)

        client.create_commit_status(status)
      end
    end
  end
end
