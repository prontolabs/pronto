module Pronto
  describe Status do
    let(:status) { described_class.new(sha, state, context, description) }
    let(:sha) { '3e0e3ab' }
    let(:state) { 'state' }
    let(:context) { 'context' }
    let(:description) { 'desc' }

    describe '==' do
      context 'itself' do
        subject { status == status }
        it { should be_truthy }
      end
    end

    describe '#to_s' do
      subject { status.to_s }
      it { should == '[3e0e3ab] context state - desc' }
    end
  end
end
