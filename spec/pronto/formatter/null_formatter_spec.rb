require 'spec_helper'

module Pronto
  module Formatter
    describe NullFormatter do
      let(:text_formatter) { NullFormatter.new }

      describe '#format' do
        subject { text_formatter.format(messages, nil) }
        let(:messages) { [message, message] }
        let(:message) { Message.new('path/to', line, :warning, 'crucial') }
        let(:line) { double(new_lineno: 1, commit_sha: '123') }

        it { should be_nil }
      end
    end
  end
end
