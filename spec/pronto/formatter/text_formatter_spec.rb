require 'spec_helper'

module Pronto
  module Formatter
    describe TextFormatter do
      let(:formatter) { described_class.new }

      describe '#format' do
        subject { formatter.format(messages, nil) }
        let(:messages) { [message, message] }
        let(:message) { Message.new('path/to', line, :warning, 'crucial') }
        let(:line) { double(new_lineno: 1, commit_sha: '123') }

        its(:count) { should == 2 }
        its(:first) { should == 'path/to:1 W: crucial' }

        context 'message without path' do
          let(:message) { Message.new(nil, line, :warning, 'careful') }

          its(:count) { should == 2 }
          its(:first) { should == ':1 W: careful' }
        end

        context 'message without line' do
          let(:message) { Message.new('path/to', nil, :warning, 'careful') }

          its(:count) { should == 2 }
          its(:first) { should == 'path/to: W: careful' }
        end
      end
    end
  end
end
