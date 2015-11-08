module Pronto
  module Formatter
    describe CheckstyleFormatter do
      let(:formatter) { described_class.new }

      describe '#format' do
        subject { formatter.format(messages, nil, nil) }
        let(:line) { double(new_lineno: 1, commit_sha: '123') }
        let(:error) { Message.new('path/to', line, :error, 'Line Error') }
        let(:warning) { Message.new('path/to', line, :warning, 'Line Warning') }
        let(:messages) { [error, warning] }

        it { should eq load_fixture('message_with_path.xml') }

        context 'message without path' do
          let(:error) { Message.new(nil, line, :error, 'Line Error') }

          it { should eq load_fixture('message_without_path.xml') }
        end

        context 'message without line' do
          let(:error) { Message.new('path/to', nil, :error, 'Line Error') }

          it { should eq load_fixture('message_without_line.xml') }
        end
      end
    end
  end
end
