module Pronto
  module Formatter
    class BitbucketPullRequestFormatter < PullRequestFormatter
      def client_module
        Bitbucket
      end

      def pretty_name
        'BitBucket'
      end
    end
  end
end
