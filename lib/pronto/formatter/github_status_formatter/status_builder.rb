require_relative 'sentence'

module Pronto
  module Formatter
    class GithubStatusFormatter
      class StatusBuilder
        def initialize(messages, level_mapping)
          @messages = messages
          @level_mapping = level_mapping
          @cached_lm = {}
        end

        def description
          desc = map_description
          desc.empty? ? NO_ISSUES_DESCRIPTION : "Found #{desc}."
        end

        def state
          failure? ? :failure : :success
        end

        private

        def failure?
          @messages.any? { |message| failure_message?(message) }
        end

        def failure_message?(message)
          message_state(message) == :failure
        end

        def message_state(message)
          level_mapping(message.runner)[message.level]
        end

        def level_mapping(runner)
          @cached_lm[runner] ||= DEFAULT_LEVEL_TO_STATE_MAPPING.merge(@level_mapping[runner] || {})
        end

        def map_description
          words = count_issue_types.map do |issue_type, issue_count|
            pluralize(issue_count, issue_type)
          end

          Sentence.new(words).to_s
        end

        def count_issue_types
          counts = @messages.each_with_object(Hash.new(0)) do |message, r|
            r[message.level] += 1
          end
          order_by_severity(counts)
        end

        def order_by_severity(counts)
          Hash[counts.sort_by { |k, _v| Pronto::Message::LEVELS.index(k) }]
        end

        def pluralize(count, word)
          "#{count} #{word}#{count > 1 ? 's' : ''}"
        end

        DEFAULT_LEVEL_TO_STATE_MAPPING = {
          info: :success,
          warning: :failure,
          error: :failure,
          fatal: :failure
        }.freeze

        NO_ISSUES_DESCRIPTION = 'Coast is clear!'.freeze

        private_constant :DEFAULT_LEVEL_TO_STATE_MAPPING, :NO_ISSUES_DESCRIPTION
      end
    end
  end
end
