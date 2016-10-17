module Pronto
  describe Pronto do
    describe '.run' do
      subject { Pronto.run(commit, repo, Formatter::NullFormatter.new, file) }
      let(:commit) { '3e0e3ab' }
      let(:repo) { 'spec/fixtures/test.git' }
      let(:file) { nil }

      context 'no runners' do
        before { Runner.runners.clear }
        it { should be_empty }
      end

      context 'master' do
        let(:commit) { 'master' }
        it { should be_empty }
      end

      context 'a single runner' do
        class Shakespeare
          def self.title
            'shakespeare'
          end

          def initialize(patches, _)
            @patches = patches
          end

          def run
            @patches.flat_map(&:added_lines).flat_map do |line|
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
  end
end
