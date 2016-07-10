module Pronto
  module Formatter
    class GitlabFormatter < CommitFormatter
      def client_module
        Gitlab
      end

      def pretty_name
        'GitLab'
      end

      def line_number(message)
        message.line.commit_line.new_lineno
      end
    end
  end
end
