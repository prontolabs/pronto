module Pronto
  module Formatter
    class NullFormatter < Base
      def self.name
        'null'
      end

      def format(_messages, _repo, _patches); end
    end
  end
end

Pronto::Formatter.register(Pronto::Formatter::NullFormatter)
