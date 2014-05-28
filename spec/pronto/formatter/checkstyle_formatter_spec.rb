require 'spec_helper'

module Pronto
  module Formatter
    describe CheckstyleFormatter do
      let(:checkstyle_formatter) { CheckstyleFormatter.new }

      describe '#format' do
        subject { checkstyle_formatter.format(messages, nil) }
        let(:line) { OpenStruct.new({ new_lineno: 1 }) }
        let(:error_message) { Message.new('path/to', line, :error, 'Line Error') }
        let(:warning_message) { Message.new('path/to', line, :warning, 'Line Warning') }
        let(:messages) { [error_message, warning_message] }

        it { should eq load_fixture('message_with_path.xml') }

        context 'message without path' do
          let(:error_message) { Message.new(nil, line, :error, 'Line Error') }

          it { should eq load_fixture('message_without_path.xml') }
        end

        context 'message without line' do
          let(:error_message) { Message.new('path/to', nil, :error, 'Line Error') }

          it { should eq load_fixture('message_without_line.xml') }
        end
      end
    end
  end
end
