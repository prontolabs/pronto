require 'spec_helper'
require 'ostruct'

module Pronto
  module Formatter
    describe TextFormatter do
      let (:text_formatter) { TextFormatter.new }

      describe '#format' do
        subject { text_formatter.format(messages) }
        let(:messages) { [message, message] }
        let(:message) { Message.new('path/to', line, :warning, 'crucial') }
        let(:line) { OpenStruct.new({new_lineno: 1}) }

        its(:count) { should == 2 }
        its(:first) { should == 'path/to:1 W: crucial' }
      end
    end
  end
end
