module Pronto
  module Formatter
    class BitbucketFormatter < CommitFormatter
      def client_module
        Bitbucket
      end

      def pretty_name
        'BitBucket'
      end

      def line_number(message)
        message.line.new_lineno
      end
    end
  end
end
