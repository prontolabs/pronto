module Pronto
  module Git
    describe Patch do
      let(:patch) { described_class.new(rugged_patch, repo) }

      let(:repo) { nil }

      describe '#additions' do
        subject { patch.additions }

        let(:rugged_patch) { double(stat: [15, 13]) }
        it { should == 15 }
      end

      describe '#deletions' do
        subject { patch.deletions }

        let(:rugged_patch) { double(stat: [5, 17]) }
        it { should == 17 }
      end

      describe '#lines' do
        subject { patch.lines }

        let(:hunks) { [double(lines: [1, 2]), double(lines: [3])] }
        let(:rugged_patch) { double(hunks: hunks) }
        its(:count) { should == 3 }
      end

      describe '#new_file_full_path' do
        subject { patch.new_file_full_path }

        let(:rugged_patch) do
          double(delta: double(new_file: { path: 'test.md' }))
        end
        let(:repo) { double(path: Pathname.new('/house/of/cards')) }
        its(:to_s) { should == '/house/of/cards/test.md' }
      end
    end
  end
end
