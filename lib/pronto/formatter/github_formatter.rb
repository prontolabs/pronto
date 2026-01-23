# frozen_string_literal: true

module Pronto
  module Formatter
    class GithubFormatter < CommitFormatter
      def self.name
        'github'
      end

      def client_module
        Github
      end

      def pretty_name
        'GitHub'
      end

      def line_number(message, _)
        message.line&.commit_line&.position
      end
    end
  end
end

Pronto::Formatter.register(Pronto::Formatter::GithubFormatter)
