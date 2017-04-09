module Pronto
  module Git
    describe Patches do
      let(:patches) { described_class.new(repo, commit, patch_array) }
      let(:repo) { nil }
      let(:commit) { nil }
      let(:patch_array) { [] }

      describe '#repo' do
        subject { patches.repo }

        context 'non-nil repo' do
          let(:repo) { double }
          it { should_not be_nil }
        end
      end

      describe '#reject' do
        subject { patches.reject { |_| true } }
        let(:patch_array) { [double(new_file_full_path: 1)] }

        it 'does not modify original' do
          subject.to_a.should be_empty
          patches.to_a.should_not be_empty
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
