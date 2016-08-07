module Pronto
  module Git
    describe Repository do
      let(:repo) { described_class.new('spec/fixtures/test.git') }

      describe '#path' do
        subject { repo.path }
        its(:to_s) { should end_with 'pronto/spec/fixtures' }
      end

      describe '#branch' do
        subject { repo.branch }
        it { should == 'master' }
      end

      describe '#remote_urls' do
        subject { repo.remote_urls }
        it { should be_empty }
      end

      describe '#commits_until' do
        subject { repo.commits_until(sha) }

        context 'initial' do
          let(:sha) { '3e0e3ab' }
          it 'should list all the commits' do
            should == %w(64dadfdb7c7437476782e8eb024085862e6287d6
                         7b21c8f4dfb0b8aa39739fc16678c5934877a414
                         577afa184c9bc82a66c40047d0809e5fcc43489f
                         ec05bab7d263d5e01be99f2c4e10a5974e24e6de
                         d6d56582ebfd0c6c3263ea4c4e2d727048370124
                         ac86326d7231ad77dab94e2c4f6f61245a2d9bec
                         3e0e3ab0a436fc2a9c05253a439dc6084699b7d5)
          end
        end

        context 'last' do
          let(:sha) { '64dadfd' }
          it do
            should contain_exactly('64dadfdb7c7437476782e8eb024085862e6287d6')
          end
        end
      end

      describe '#show_commit' do
        subject { repo.show_commit(sha) }

        context 'initial' do
          let(:sha) { '3e0e3ab' }
          it { should be_none }
        end

        context 'last' do
          let(:sha) { '64dadfd' }
          it { should be_one }
        end
      end

      describe '#diff' do
        subject { repo.diff(sha) }

        context 'initial' do
          let(:sha) { '3e0e3ab' }
          it { should be_one }
        end

        context 'last' do
          let(:sha) { '64dadfd' }
          it { should be_none }
        end

        context 'index' do
          let(:sha) { :index }
          it { should be_one }
        end
      end

      describe '#blame' do
        subject { repo.blame('hamlet.txt', 1) }

        it do
          should match a_hash_including(
            orig_start_line_number: 1,
            orig_commit_id: 'ac86326d7231ad77dab94e2c4f6f61245a2d9bec',
            final_start_line_number: 1,
            final_commit_id: 'ac86326d7231ad77dab94e2c4f6f61245a2d9bec'
          )
        end
      end
    end
  end
end
