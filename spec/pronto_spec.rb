module Pronto
  describe Pronto do
    describe '.run' do
      subject { Pronto.run(commit, repo, Formatter::NullFormatter.new, file) }
      let(:commit) { '3e0e3ab' }
      let(:repo) { 'spec/fixtures/test.git' }
      let(:file) { nil }

      context 'no runners' do
        it { should be_empty }
      end

      context 'master' do
        let(:commit) { 'master' }
        it { should be_empty }
      end

      context 'a single runner' do
        class Shakespeare
          def run(patches, _)
            patches.flat_map(&:added_lines).flat_map do |line|
              [new_message(line)] if no_more?(line)
            end
          end

          def new_message(line)
            Message.new('hamlet.txt', line, :error, 'No more')
          end

          def no_more?(line)
            line.content.include?('No more')
          end
        end

        before { Runner.runners << Shakespeare if Runner.runners.empty? }

        context 'all files' do
          its(:count) { should == 1 }
        end

        context 'specific file' do
          let(:file) { 'hamlet.txt' }
          its(:count) { should == 1 }
        end

        context 'non-existant file' do
          let(:file) { 'lear.txt' }
          it { should be_empty }
        end
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
        let(:gem) { double(name: 'pronto-rubocop') }
        let(:gems) { [gem, gem] }
        it { should include('rubocop') }
        its(:count) { should == 1 }
      end

      context 'inproperly named gem' do
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
