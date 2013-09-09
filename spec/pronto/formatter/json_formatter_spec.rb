require 'spec_helper'
require 'ostruct'

module Pronto
  module Formatter
    describe JsonFormatter do
      let (:json_formatter) { JsonFormatter.new }

      describe '#format' do
        subject { json_formatter.format(messages) }
        let(:messages) { [message, message] }
        let(:message) { Message.new('path/to', line, :warning, 'crucial') }
        let(:line) { OpenStruct.new({new_lineno: 1}) }

        it { should == '[{"path":"path/to","line":1,"level":"W","message":"crucial"},{"path":"path/to","line":1,"level":"W","message":"crucial"}]' }
      end
    end
  end
end
