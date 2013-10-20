require 'spec_helper'
require 'ostruct'

module Pronto
  module Formatter
    describe TextFormatter do
      let(:text_formatter) { TextFormatter.new }

      describe '#format' do
        subject { text_formatter.format(messages, nil) }
        let(:messages) { [message, message] }
        let(:message) { Message.new('path/to', line, :warning, 'crucial') }
        let(:line) { OpenStruct.new({ new_lineno: 1 }) }

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
