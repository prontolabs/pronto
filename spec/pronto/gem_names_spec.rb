module Pronto
  describe GemNames do
    let(:gem_names) { described_class.new }

    describe '.to_a' do
      subject { gem_names.to_a }
      before { Gem::Specification.should_receive(:find_all) { gems } }

      context 'properly named gem' do
        let(:gems) { [double(name: 'pronto-rubocop')] }
        it { should include('rubocop') }
      end

      context 'duplicate names' do
        let(:gem) { double(name: 'pronto-rubocop') }
        let(:gems) { [gem, gem] }
        it { should include('rubocop') }
        its(:count) { should == 1 }
      end

      context 'improperly named gem' do
        context 'with good path' do
          let(:gems) { [double(name: 'good', full_gem_path: '/good')] }
          before do
            File.stub(:exist?).with('/good/lib/pronto/good.rb').and_return(true)
          end
          it { should include('good') }
        end

        context 'with bad path' do
          let(:gems) { [double(name: 'bad', full_gem_path: '/bad')] }
          before do
            File.stub(:exist?).with('/bad/lib/pronto/bad.rb').and_return(false)
          end
          it { should_not include('bad') }
        end
      end
    end
  end
end
