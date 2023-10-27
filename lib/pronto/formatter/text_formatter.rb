require 'pronto/formatter/text_message_decorator'

module Pronto
  module Formatter
    class TextFormatter < Base
      def self.name
        'text'
      end

      def format(messages, _repo, _patches)
        messages.map do |message|
          message_format = config.message_format(self.class.name)
          message_data = TextMessageDecorator.new(message).to_h
          (message_format % message_data).strip
        end
      end
    end
  end
end

Pronto::Formatter.register(Pronto::Formatter::TextFormatter)
