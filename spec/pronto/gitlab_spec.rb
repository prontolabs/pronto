module Pronto
  describe Gitlab do
    let(:gitlab) { described_class.new(repo) }

    describe '#slug' do
      subject { gitlab.send(:slug) }
      before(:each) do
        ENV['PRONTO_GITLAB_API_ENDPOINT'] = 'http://gitlab.example.com/api/v3'
        ENV['PRONTO_GITLAB_API_PRIVATE_TOKEN'] = 'token'
      end

      context 'ssh with port remote url' do
        let(:repo) do
          remote_url = 'ssh://git@gitlab.example.com:111/mmozuras/pronto.git'
          double(remote_urls: [remote_url])
        end

        it 'returns correct slug' do
          subject.should eql('mmozuras/pronto')
        end
      end

      context 'git remote url' do
        let(:repo) do
          double(remote_urls: ['git@gitlab.example.com:mmozuras/pronto.git'])
        end

        it 'returns correct slug' do
          subject.should eql('mmozuras/pronto')
        end
      end
    end

    describe '#commit_comments' do
      subject { gitlab.commit_comments(sha) }

      context 'three requests for same comments' do
        let(:repo) do
          double(remote_urls: ['git@gitlab.example.com:mmozuras/pronto.git'])
        end
        let(:sha) { 'foobar' }
        let(:comment) { double(note: 'body', path: 'path', line: 1) }

        specify do
          ENV['PRONTO_GITLAB_API_ENDPOINT'] = 'http://gitlab.example.com/api/v3'
          ENV['PRONTO_GITLAB_API_PRIVATE_TOKEN'] = 'token'

          ::Gitlab::Client.any_instance
            .should_receive(:commit_comments)
            .with('mmozuras/pronto', sha, per_page: 500)
            .once
            .and_return([comment])

          subject
          subject
          subject
        end
      end
    end
  end
end
