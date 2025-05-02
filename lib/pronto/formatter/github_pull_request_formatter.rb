module Pronto
  module Formatter
    class GithubPullRequestFormatter < PullRequestFormatter
      def self.name
        'github_pr'
      end

      def client_module
        Github
      end

      def pretty_name
        'GitHub'
      end

      def line_number(message, _)
        message.line&.new_lineno
      end

      def remove_outdated_comments(client, outdated_comments)
        outdated_comments.each do |comment|
          client.delete_comment(comment)
        end
      rescue Octokit::UnprocessableEntity, HTTParty::Error => e
        warn "Failed to delete: #{e.message}"
      end
    end
  end
end

Pronto::Formatter.register(Pronto::Formatter::GithubPullRequestFormatter)
