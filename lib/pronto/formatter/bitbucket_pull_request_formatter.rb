module Pronto
  module Formatter
    class BitbucketPullRequestFormatter < PullRequestFormatter
      def client_module
        Bitbucket
      end

      def pretty_name
        'BitBucket'
      end

      def line_number(message, _)
        message.line.line.new_lineno if message.line
      end

      def approve_pull_request(comments_count, additions_count, client)
        return if config.bitbucket_auto_approve == false

        if comments_count > 0 && additions_count > 0
          client.unapprove_pull_request  
        elsif comments_count == 0
          client.approve_pull_request
        end
      end
    end
  end
end
