module Pronto
  module Formatter
    describe Colorizable do
      let(:formatter_class) do
        klass = described_class

        Class.new(TextFormatter) do
          include klass
        end
      end

      let(:formatter) do
        formatter_class.new
      end

      describe '#colorize' do
        subject { formatter.colorize('Warning', :yellow) }

        context 'in TTY' do
          before { $stdout.stub(:tty?) { true } }

          it 'colorizes the passed string' do
            should eq("\e[33mWarning\e[0m")
          end
        end

        context 'not in TTY' do
          before { $stdout.stub(:tty?) { false } }

          it 'returns the passed string' do
            should eq('Warning')
          end
        end
      end
    end
  end
end
