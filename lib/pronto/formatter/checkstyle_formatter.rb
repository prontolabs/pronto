require 'rexml/document'

module Pronto
  module Formatter
    class CheckstyleFormatter < Base
      def initialize
        @output = ''
      end

      def format(messages, _repo, _patches)
        open_xml
        process_messages(messages)
        close_xml

        @output
      end

      private

      def open_xml
        @document = REXML::Document.new.tap do |d|
          d << REXML::XMLDecl.new
        end
        @checkstyle = REXML::Element.new('checkstyle', @document)
      end

      def process_messages(messages)
        messages.group_by(&:path).map do |path, path_messages|
          REXML::Element.new('file', @checkstyle).tap do |file|
            file.attributes['name'] = path
            add_file_messages(path_messages, file)
          end
        end
      end

      def add_file_messages(path_messages, file)
        path_messages.each do |message|
          REXML::Element.new('error', file).tap do |e|
            e.attributes['line'] = message.line.new_lineno if message.line
            e.attributes['severity'] = to_checkstyle_severity(message.level)
            e.attributes['message'] = message.msg
            e.attributes['source'] = 'com.puppycrawl.tools.checkstyle.pronto'
          end
        end
      end

      def close_xml
        @document.write(@output, 2)
      end

      def to_checkstyle_severity(pronto_level)
        case pronto_level
        when :error, :fatal then 'error'
        else pronto_level.to_s
        end
      end
    end
  end
end
