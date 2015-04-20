require 'spec_helper'

module Pronto
  describe Message do
    let(:message) { Message.new(path, line, level, msg, '8cda581') }

    let(:path) { 'README.md' }
    let(:line) { Git::Line.new }
    let(:msg) { 'message' }
    let(:level) { :warning }

    describe '.new' do
      subject { message }

      Message::LEVELS.each do |message_level|
        context "set log level to #{message_level}" do
          let(:level) { message_level }
          its(:level) { should == message_level }
        end
      end

      context 'bad level' do
        let(:level) { :random }
        specify do
          -> { subject }.should raise_error
        end
      end
    end

    describe '#full_path' do
      subject { message.full_path }

      context 'line is nil' do
        let(:line) { nil }
        it { should be_nil }
      end
    end

    describe '#repo' do
      subject { message.repo }

      context 'line is nil' do
        let(:line) { nil }
        it { should be_nil }
      end
    end
  end
end
