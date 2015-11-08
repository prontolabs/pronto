module Pronto
  describe Runners do
    describe '#run' do
      subject { described_class.new(runners).run(patches) }
      let(:patches) { double(commit: nil) }

      context 'no runners' do
        let(:runners) { [] }
        it { should be_empty }
      end

      context 'fake runner' do
        class FakeRunner
          def run(_, _)
            [1, nil, [3]]
          end
        end

        let(:runners) { [FakeRunner] }
        it { should == [1, 3] }
      end
    end
  end
end
