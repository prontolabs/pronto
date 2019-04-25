# frozen_string_literal: true

require 'cgi'
require 'erb'
require 'ostruct'
require 'base64'

module Pronto
  module Formatter
    class HtmlFormatter < Base
      ELLIPSES = '<span class="extra-code">...</span>'.freeze
      TEMPLATE_PATH =
        File.expand_path('../assets/output.html.erb', __dir__)

      Color = Struct.new(:red, :green, :blue, :alpha) do
        def to_s
          "rgba(#{values.join(', ')})"
        end

        def fade_out(amount)
          dup.tap do |color|
            color.alpha -= amount
          end
        end
      end

      attr_reader :files, :summary

      def format(messages, _, _)
        render_html(messages)
      end

      def render_html(messages)
        context = ERBContext.new(messages)

        template = File.read(TEMPLATE_PATH, encoding: Encoding::UTF_8)

        erb = if RUBY_VERSION >= '2.6'
                ERB.new(template, trim_mode: '-')
              else
                ERB.new(template, nil, '-')
              end
        html = erb.result(context.binding)

        html
      end

      # This class provides helper methods used in the ERB template.
      class ERBContext
        # include PathUtil
        # include TextUtil

        SEVERITY_COLORS = {
          refactor: Color.new(0xED, 0x9C, 0x28, 1.0),
          convention: Color.new(0xED, 0x9C, 0x28, 1.0),
          warning: Color.new(0x96, 0x28, 0xEF, 1.0),
          error: Color.new(0xD2, 0x32, 0x2D, 1.0),
          fatal: Color.new(0xD2, 0x32, 0x2D, 1.0)
        }.freeze

        LOGO_IMAGE_PATH =
          File.expand_path('../assets/logo.png', __dir__)

        attr_reader :messages, :summary

        def initialize(messages)
          @messages = messages.sort_by(&:path)
          @summary = 'IMPLEMENT LATER'
        end

        # Make Kernel#binding public.
        def binding
          super
        end

        def decorated_message(message)
          message.msg.gsub(/`(.+?)`/) do
            "<code>#{Regexp.last_match(1)}</code>"
          end
        end

        # def highlighted_source_line(message)
        #   source_before_highlight(message) +
        #     hightlight_source_tag(message) +
        #     source_after_highlight(message) +
        #     possible_ellipses(message.location)
        # end

        # def hightlight_source_tag(message)
        #   "<span class=\"highlight #{message.level}\">" \
        #     "#{escape(offense.highlighted_area.source)}" \
        #     '</span>'
        # end

        # def source_before_highlight(message)
        #   source_line = message.location.source_line
        #   escape(source_line[0...message.highlighted_area.begin_pos])
        # end

        # def source_after_highlight(offense)
        #   source_line = offense.location.source_line
        #   escape(source_line[offense.highlighted_area.end_pos..-1])
        # end

        # def possible_ellipses(location)
        #   location.first_line == location.last_line ? '' : " #{ELLIPSES}"
        # end

        def escape(string)
          CGI.escapeHTML(string)
        end

        def base64_encoded_logo_image
          image = File.read(LOGO_IMAGE_PATH, binmode: true)
          Base64.encode64(image)
        end
      end
    end
  end
end

