module Pronto
  module Formatter
    class GitlabFormatter < CommitFormatter
      def self.name
        'gitlab'
      end

      def client_module
        Gitlab
      end

      def pretty_name
        'GitLab'
      end

      def line_number(message, _)
        message.line.commit_line.new_lineno if message.line
      end
    end
  end
end

Pronto::Formatter.register(Pronto::Formatter::GitlabFormatter)
