module Pronto
  module Formatter
    class GithubPullRequestFormatter < PullRequestFormatter
      def client_module
        Github
      end

      def pretty_name
        'GitHub'
      end
    end
  end
end
