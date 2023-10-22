require_relative 'sentence'

module Pronto
  module Formatter
    class GithubStatusFormatter < Base
      class StatusBuilder
        def initialize(runner, messages)
          @runner = runner
          @messages = messages
        end

        def description
          desc = map_description
          desc.empty? ? NO_ISSUES_DESCRIPTION : "Found #{desc}."
        end

        def state
          failure? ? :failure : :success
        end

        def context
          "pronto/#{@runner.title}"
        end

        private

        def failure?
          @messages.any? { |message| failure_message?(message) }
        end

        def failure_message?(message)
          message_state(message) == :failure
        end

        def message_state(message)
          DEFAULT_LEVEL_TO_STATE_MAPPING[message.level]
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
