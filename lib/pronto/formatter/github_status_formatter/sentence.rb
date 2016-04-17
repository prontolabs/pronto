module Pronto
  module Formatter
    class GithubStatusFormatter
      class Sentence
        def initialize(words)
          @words = words
        end

        def to_s
          case words.size
          when 0
            ''
          when 1
            words[0].to_s.dup
          when 2
            "#{words[0]}#{WORD_CONNECTORS[:two_words_connector]}#{words[1]}"
          else
            to_oxford_comma_sentence
          end
        end

        private

        attr_reader :words

        WORD_CONNECTORS = {
          words_connector: ', ',
          two_words_connector: ' and ',
          last_word_connector: ', and '
        }.freeze

        private_constant :WORD_CONNECTORS

        def to_oxford_comma_sentence
          "#{words[0...-1].join(WORD_CONNECTORS[:words_connector])}"\
            "#{WORD_CONNECTORS[:last_word_connector]}"\
            "#{words[-1]}"
        end
      end
    end
  end
end
