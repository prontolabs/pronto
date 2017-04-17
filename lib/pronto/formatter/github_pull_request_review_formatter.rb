module Pronto
  module Formatter
    class GithubPullRequestReviewFormatter < PullRequestFormatter
      def client_module
        Github
      end

      def pretty_name
        'GitHub'
      end

      def submit_comments(client, comments)
        client.create_pull_request_review(comments)
      rescue Octokit::UnprocessableEntity, HTTParty::Error => e
        $stderr.puts "Failed to post: #{e.message}"
      end

      def line_number(message, patches)
        line = patches.find_line(message.full_path, message.line.new_lineno)
        line.position
      end
    end
  end
end
