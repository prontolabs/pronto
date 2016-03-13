module Pronto
  describe Runner do
    let(:runner) { described_class.new([]) }

    describe '#ruby_file?' do
      subject { runner.ruby_file?(path) }

      context 'ending with .rb' do
        let(:path) { 'test.rb' }
        it { should be_truthy }
      end

      context 'ending with .rb in directory' do
        let(:path) { 'amazing/test.rb' }
        it { should be_truthy }
      end

      context 'ending with .rake' do
        let(:path) { 'test.rake' }
        it { should be_truthy }
      end

      context 'executable' do
        let(:path) { 'test' }
        before { File.stub(:open).with(path).and_return(shebang) }

        context 'ruby' do
          let(:shebang) { '#!ruby' }
          it { should be_truthy }
        end

        context 'bash' do
          let(:shebang) { '#! bash' }
          it { should be_falsy }
        end
      end

      context 'directory' do
        let(:path) { 'directory' }
        before { File.stub(:directory?).with(path).and_return(true) }
        it { should be_falsy }
      end
    end
  end
end
