module Pronto
  module Git
    describe Line do
      let(:line) { described_class.new(rugged_line, patch, hunk) }

      let(:patch) { nil }
      let(:hunk) { nil }

      describe '#addition?' do
        subject { line.addition? }

        let(:rugged_line) { double(addition?: true) }
        it { should == true }
      end

      describe '#deletion?' do
        subject { line.deletion? }

        let(:rugged_line) { double(deletion?: false) }
        it { should == false }
      end

      describe '#content' do
        subject { line.content }

        let(:rugged_line) { double(content: 'hello') }
        it { should == 'hello' }
      end

      describe '#new_lineno' do
        subject { line.new_lineno }

        let(:rugged_line) { double(new_lineno: 1) }
        it { should == 1 }
      end

      describe '#old_lineno' do
        subject { line.old_lineno }

        let(:rugged_line) { double(old_lineno: 42) }
        it { should == 42 }
      end

      describe '#line_origin' do
        subject { line.line_origin }

        let(:rugged_line) { double(line_origin: 15) }
        it { should == 15 }
      end

      describe '#==' do
        subject { line == other }

        let(:rugged_line) do
          double(content: 'hello',
                 line_origin: 2,
                 new_lineno: 10,
                 old_lineno: 11)
        end

        context 'equal' do
          let(:other) { rugged_line }
          it { should == true }
        end

        context 'different' do
          let(:other) do
            double(content: 'Bob',
                   line_origin: 7,
                   new_lineno: 17,
                   old_lineno: 17)
          end
          it { should == false }
        end
      end
    end
  end
end
