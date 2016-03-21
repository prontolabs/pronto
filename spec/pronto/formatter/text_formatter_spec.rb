module Pronto
  module Formatter
    describe TextFormatter do
      let(:formatter) { described_class.new }

      before { $stdout.stub(:tty?) { false } }

      describe '#format' do
        subject { formatter.format(messages, nil, nil) }
        let(:messages) { [message, message] }
        let(:message) { Message.new('path/to', line, :warning, 'crucial') }
        let(:line) { double(new_lineno: 1, commit_sha: '123') }

        its(:count) { should == 2 }
        its(:first) { should == 'path/to:1 W: crucial' }

        context 'message with commit SHA' do
          let(:message) { Message.new(nil, nil, :warning, 'careful', '8d79b5') }

          its(:count) { should == 2 }
          its(:first) { should == '8d79b5 W: careful' }
        end

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

        context 'message without line, path and commit SHA' do
          let(:message) { Message.new(nil, nil, :warning, 'careful', nil) }

          its(:count) { should == 2 }
          its(:first) { should == 'W: careful' }
        end

        context 'in TTY' do
          before { $stdout.stub(:tty?) { true } }

          context 'message with commit SHA' do
            let(:message) { Message.new(nil, nil, :warning, 'msg', '8d79b5') }

            its(:first) { should == "\e[36m8d79b5\e[0m \e[35mW\e[0m: msg" }
          end

          context 'message without path' do
            let(:message) { Message.new(nil, line, :warning, 'msg') }

            its(:first) { should == ":1 \e[35mW\e[0m: msg" }
          end

          context 'message without line' do
            let(:message) { Message.new('path/to', nil, :warning, 'msg') }

            its(:first) { should == "\e[36mpath/to\e[0m: \e[35mW\e[0m: msg" }
          end

          context 'message without line, path and commit SHA' do
            let(:message) { Message.new(nil, nil, :warning, 'careful', nil) }

            its(:count) { should == 2 }
            its(:first) { should == "\e[35mW\e[0m: careful" }
          end

          context 'info message' do
            let(:message) { Message.new('path/to', line, :info, 'msg') }

            its(:first) { should == "\e[36mpath/to\e[0m:1 \e[33mI\e[0m: msg" }
          end

          context 'warning message' do
            let(:message) { Message.new('path/to', line, :warning, 'msg') }

            its(:first) { should == "\e[36mpath/to\e[0m:1 \e[35mW\e[0m: msg" }
          end

          context 'error message' do
            let(:message) { Message.new('path/to', line, :error, 'msg') }

            its(:first) { should == "\e[36mpath/to\e[0m:1 \e[31mE\e[0m: msg" }
          end

          context 'fatal message' do
            let(:message) { Message.new('path/to', line, :fatal, 'msg') }

            its(:first) { should == "\e[36mpath/to\e[0m:1 \e[31mF\e[0m: msg" }
          end
        end
      end
    end
  end
end
