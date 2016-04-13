require_relative 'github_status_formatter/sentence'

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
        state = state(messages)
        description = status_description(messages)
        status = Github::Status.new(sha, state, runner.name, description)

        client.create_commit_status(status)
      end

      def state(messages)
        failure?(messages) ? :failure : :success
      end

      def failure?(messages)
        messages.any? do |message|
          level_mapping(message.runner)[message.level] == :failure
        end
      end

      def level_mapping(runner)
        DEFAULT_LEVEL_TO_STATE_MAPPING.merge(@level_mapping[runner] || {})
      end

      def status_description(messages)
        desc = map_description(messages)
        desc.empty? ? 'Coast is clear!' : "Found #{desc}."
      end

      def map_description(messages)
        counted_issue_types = count_issue_types(messages)

        words = counted_issue_types.map do |issue_type, issue_count|
          pluralize(issue_count, issue_type)
        end

        Pronto::Formatter::GithubStatusFormatter::Sentence.new(words).to_s
      end

      def count_issue_types(messages)
        counts = messages.each_with_object(Hash.new(0)) do |message, r|
          r[message.level] += 1
        end
        order_by_severity(counts)
      end

      def order_by_severity(counts)
        Hash[counts.sort_by { |k, _v| Pronto::Message::LEVELS.index(k) }]
      end

      def pluralize(count, word)
        "#{count} #{word}#{count > 1 ? 's' : ''}"
      end

      DEFAULT_LEVEL_TO_STATE_MAPPING = {
        info: :success,
        warning: :failure,
        error: :failure,
        fatal: :failure
      }.freeze

      private_constant :DEFAULT_LEVEL_TO_STATE_MAPPING
    end
  end
end
