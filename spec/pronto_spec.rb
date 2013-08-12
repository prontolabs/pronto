require 'spec_helper'

describe Pronto do
  describe '.run' do
    subject { Pronto.run(commit1, commit2, path_to_repo) }

    let(:commit1) { '2c763a5' }
    let(:commit2) { '21cd33a'}
    let(:path_to_repo) { File.join(File.dirname(__FILE__), '../') }

    context 'no runners available' do
      before { Pronto::Runner.stub(:runners).and_return([]) }
      it { should == [] }
    end
  end

  describe '.gem_names' do
    subject { Pronto.gem_names }
    before { Gem::Specification.should_receive(:find_all) { gems } }

    context 'properly named gem' do
      let(:gems) { [double(name: 'pronto-rubocop')] }
      it { should include('rubocop') }
    end

    context 'duplicate names' do
      let(:gems) { [double(name: 'pronto-rubocop'),
                    double(name: 'pronto-rubocop')] }
      it { should include('rubocop') }
      its(:count) { should == 1 }
    end

    context 'inproperly named gem' do
      context 'with good path' do
        let(:gems) { [double(name: 'good', full_gem_path: '/good')] }
        before { File.stub(:exists?).with('/good/lib/pronto/good.rb') { true } }
        it { should include('good') }
      end

      context 'with bad path' do
        let(:gems) { [double(name: 'bad', full_gem_path: '/bad')] }
        before { File.stub(:exists?).with('/bad/lib/pronto/bad.rb') { false } }
        it { should_not include('bad') }
      end
    end
  end
end
