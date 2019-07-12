module Pronto
  module Formatter
    class GitlabMergeRequestReviewFormatter < PullRequestFormatter
      def client_module
        Gitlab
      end

      def pretty_name
        'Gitlab'
      end

      def submit_comments(client, comments)
        client.create_pull_request_review(comments)
      # rescue => e
      #   $stderr.puts "Failed to post: #{e.message}"
      end

      def line_number(message, _)
        message.line.line.new_lineno if message.line
      end
    end
  end
end
