module Pronto
  module Formatter
    describe JsonFormatter do
      let(:formatter) { described_class.new }

      describe '#format' do
        subject { formatter.format(messages, nil, nil) }
        let(:messages) { [message, message] }
        let(:message) { Message.new('path/to', line, :warning, 'crucial') }
        let(:line) { double(new_lineno: 1, commit_sha: nil) }
        let(:runner) { Class }

        it do
          should ==
            '[{"level":"W","message":"crucial","path":"path/to","line":1},'\
            '{"level":"W","message":"crucial","path":"path/to","line":1}]'
        end

        context 'message without path' do
          let(:message) { Message.new(nil, line, :warning, 'careful') }

          it do
            should == '[{"level":"W","message":"careful","line":1},'\
              '{"level":"W","message":"careful","line":1}]'
          end
        end

        context 'message without line' do
          let(:message) { Message.new('path/to', nil, :warning, 'careful') }

          it do
            should == '[{"level":"W","message":"careful","path":"path/to"},'\
              '{"level":"W","message":"careful","path":"path/to"}]'
          end
        end

        context 'message with a runner' do
          let(:message) do
            Message.new(nil, line, :warning, 'careful', nil, runner)
          end

          it do
            should ==
              '[{"level":"W","message":"careful","line":1,"runner":"Class"},'\
              '{"level":"W","message":"careful","line":1,"runner":"Class"}]'
          end
        end
      end
    end
  end
end
