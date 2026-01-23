# frozen_string_literal: true

module Pronto
  module Formatter
    class BitbucketPullRequestFormatter < PullRequestFormatter
      def self.name
        'bitbucket_pr'
      end

      def client_module
        Bitbucket
      end

      def pretty_name
        'BitBucket'
      end

      def line_number(message, _)
        message.line&.line&.new_lineno
      end

      def approve_pull_request(comments_count, additions_count, client)
        return if config.bitbucket_auto_approve == false

        if comments_count.positive? && additions_count.positive?
          client.unapprove_pull_request
        elsif comments_count.zero?
          client.approve_pull_request
        end
      end
    end
  end
end

Pronto::Formatter.register(Pronto::Formatter::BitbucketPullRequestFormatter)
