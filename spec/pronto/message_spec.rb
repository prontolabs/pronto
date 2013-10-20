require 'spec_helper'

module Pronto
  describe Message do
    describe '.new' do
      subject { Message.new(path, line, level, msg, '8cda581') }
      let(:path) { 'README.md' }
      let(:line) { Rugged::Diff::Line.new }
      let(:msg) { 'message' }

      Message::LEVELS.each do |message_level|
        context "set log level to #{message_level}" do
          let(:level) { message_level }
          its(:level) { should == message_level }
        end
      end
    end
  end
end
