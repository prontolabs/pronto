module Pronto
  describe Logger do
    let(:logger) { described_class.new(io) }
    let(:io) { StringIO.new }
    let(:output) { io.string }

    describe '#log' do
      before { logger.log('hello world') }

      subject { output }

      it { should_not be_empty }
      its([-1, 1]) { should == "\n" }
    end
  end
end
