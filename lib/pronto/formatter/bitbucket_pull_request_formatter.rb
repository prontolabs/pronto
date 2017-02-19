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
    end
  end
end
