module Pronto
  module Formatter
    class GithubFormatter < CommitFormatter
      def client_module
        Github
      end

      def pretty_name
        'GitHub'
      end

      def line_number(message)
        message.line.commit_line.position
      end
    end
  end
end
