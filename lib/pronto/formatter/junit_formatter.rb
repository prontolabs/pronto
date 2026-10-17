require 'rexml/document'

module Pronto
  module Formatter
    class JunitFormatter < Base
      def self.name
        'junit'
      end

      def format(messages, repo, patches)
        document = REXML::Document.new
        document << REXML::XMLDecl.new
        testsuites = REXML::Element.new('testsuites', document)
        add_testsuite(testsuites, messages, repo, patches)

        write(document)
      end

      private

      def add_testsuite(testsuites, messages, repo, patches)
        messages_by_testcase = messages.group_by { |message| [message.path, message.runner] }
        testcases_by_path = (inspected_testcases(messages, patches) | messages_by_testcase.keys).group_by(&:first)
        testsuite = REXML::Element.new('testsuite', testsuites)
        testsuite.add_attributes('name' => 'pronto',
                                 'tests' => testcases_by_path.count.to_s,
                                 'failures' => messages.count.to_s)

        testcases_by_path.values.flatten(1).each do |path, runner|
          add_testcase(testsuite, repo, path, runner, messages_by_testcase.fetch([path, runner], []))
        end
      end

      # Mirrors Runners#run, so only file and runner pairs that were linted are listed.
      def inspected_testcases(messages, patches)
        runners = ran_runners(messages)
        excluded_files = runners.map { |runner| [runner, config.excluded_files(runner.title)] }.to_h

        inspected_patches(patches).flat_map do |patch|
          full_path = patch.new_file_full_path.to_s
          linted_runners = runners.reject { |runner| excluded_files.fetch(runner).include?(full_path) }
          linted_runners.map { |runner| [patch.new_file_path, runner] }
        end
      end

      def inspected_patches(patches)
        excluded_files = config.excluded_files('all')

        Array(patches).select do |patch|
          patch.additions.positive? && !excluded_files.include?(patch.new_file_full_path.to_s)
        end
      end

      def ran_runners(messages)
        max_warnings = config.max_warnings
        warnings = 0

        Runners.new(Runner.runners, config).active_runners.take_while do |runner|
          ran = !max_warnings || warnings < max_warnings
          warnings += messages.count { |message| message.runner == runner }
          ran
        end
      end

      def add_testcase(testsuite, repo, path, runner, messages)
        testcase = REXML::Element.new('testcase', testsuite)
        testcase.add_attributes('classname' => path.to_s.sub(/\.rb\z/, '').tr('/', '.'),
                                'name' => runner_name(runner))

        messages.each do |message|
          failure = REXML::Element.new('failure', testcase)
          failure.add_attributes('type' => runner_name(runner), 'message' => message.msg)
          failure.text = location(repo, message) if message.path
        end
      end

      def runner_name(runner)
        runner&.title || 'pronto'
      end

      def location(repo, message)
        full_path = repo.path.join(message.path).to_s
        message.line ? "#{full_path}:#{message.line.new_lineno}" : full_path
      end

      def write(document)
        output = +''
        TextPreservingFormatter.new(2).write(document, output)
        output
      end

      # Matches RuboCop's junit layout: failure text on its own line, written as is.
      class TextPreservingFormatter < REXML::Formatters::Pretty
        def write_text(node, output)
          output << (' ' * @level) << node.to_s
        end
      end
    end
  end
end

Pronto::Formatter.register(Pronto::Formatter::JunitFormatter)
