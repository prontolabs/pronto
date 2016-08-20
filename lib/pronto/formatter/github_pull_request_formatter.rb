module Pronto
  module Formatter
    class GithubPullRequestFormatter < PullRequestFormatter
      def client_module
        Github
      end

      def pretty_name
        'GitHub'
      end

      def line_number(message, patches)
        line = patches.find_line(message.full_path, message.line.new_lineno)
        line.position
      end
    end
  end
end
