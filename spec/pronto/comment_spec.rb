module Pronto
  describe Comment do
    let(:comment) { described_class.new(sha, body, path, position) }
    let(:sha) { '3e0e3ab' }
    let(:body) { 'body' }
    let(:path) { '/path/to/file' }
    let(:position) { 1 }

    describe '==' do
      context 'itself' do
        subject { comment == comment.dup }
        it { should be_truthy }
      end

      context 'other comment' do
        subject { comment == other }

        context 'different sha' do
          let(:other) { described_class.new('sha', body, path, position) }
          it { should be_truthy }
        end

        context 'different position' do
          let(:other) { described_class.new(sha, body, path, 2) }
          it { should be_falsy }
        end

        context 'different body' do
          let(:other) { described_class.new(sha, 'other', path, position) }
          it { should be_falsy }
        end

        context 'different path' do
          let(:other) { described_class.new(sha, body, '/home', position) }
          it { should be_falsy }
        end
      end
    end

    describe '#to_s' do
      subject { comment.to_s }
      it { should == '[3e0e3ab] /path/to/file:1 - body' }
    end
  end
end
