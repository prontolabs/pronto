module Pronto
  module Git
    describe Patches do
      let(:patches) { described_class.new(repo, commit, []) }
      let(:repo) { nil }
      let(:commit) { nil }

      describe '#repo' do
        subject { patches.repo }

        context 'non-nil repo' do
          let(:repo) { double }
          it { should_not be_nil }
        end
      end

      describe '#find_line' do
        subject { patches.find_line(path, line) }

        let(:path) { '/test.rb' }
        let(:line) { 1 }

        it { should be_nil }
      end
    end
  end
end
