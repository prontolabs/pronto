module Pronto
  describe Gitlab do
    let(:gitlab) { described_class.new(repo) }

    describe '#slug' do
      subject { gitlab.send(:slug) }
      before(:each) do
        ENV['PRONTO_GITLAB_API_ENDPOINT'] = 'http://gitlab.example.com/api/v4'
        ENV['PRONTO_GITLAB_API_PRIVATE_TOKEN'] = 'token'
      end

      context 'ssh with port remote url' do
        let(:repo) do
          remote_url = 'ssh://git@gitlab.example.com:111/prontolabs/pronto.git'
          double(remote_urls: [remote_url])
        end

        it 'returns correct slug' do
          subject.should eql('prontolabs/pronto')
        end
      end

      context 'git remote url' do
        let(:repo) do
          double(remote_urls: ['git@gitlab.example.com:prontolabs/pronto.git'])
        end

        it 'returns correct slug' do
          subject.should eql('prontolabs/pronto')
        end
      end

      context 'http remote url' do
        let(:repo) do
          double(remote_urls: ['https://gitlab.example.com/prontolabs/pronto.git'])
        end

        it 'returns correct slug' do
          subject.should eql('prontolabs/pronto')
        end
      end

      context 'http remote url with different host' do
        let(:repo) do
          double(remote_urls: ['https://gitlab.example.net/prontolabs/pronto.git'])
        end

        it 'returns correct slug' do
          subject.should eql('prontolabs/pronto')
        end
      end
    end

    describe '#commit_comments' do
      subject { gitlab.commit_comments(sha) }

      context 'three requests for same comments' do
        let(:repo) do
          double(remote_urls: ['git@gitlab.example.com:prontolabs/pronto.git'])
        end
        let(:sha) { 'foobar' }
        let(:comment) { double(note: 'body', path: 'path', line: 1) }
        let(:paginated_response) { double(auto_paginate: [ comment ]) }

        specify do
          ENV['PRONTO_GITLAB_API_ENDPOINT'] = 'http://gitlab.example.com/api/v4'
          ENV['PRONTO_GITLAB_API_PRIVATE_TOKEN'] = 'token'

          ::Gitlab::Client.any_instance
            .should_receive(:commit_comments)
            .with('prontolabs/pronto', sha)
            .once
            .and_return(paginated_response)

          subject
          subject
          subject
        end
      end
    end

    describe '#pull_comments' do
      subject { gitlab.pull_comments(sha) }

      context 'three requests for same comments' do
        let(:repo) do
          double(remote_urls: ['git@gitlab.example.com:prontolabs/pronto.git'])
        end
        let(:sha) { 'foobar' }
        let(:comment) { double(notes: [{'body' => 'body', 'position' => {'new_path' => 'test', 'old_path' => nil}}]) }
        let(:paginated_response) { double(auto_paginate: [ comment ]) }

        specify do
          ENV['PRONTO_GITLAB_API_ENDPOINT'] = 'http://gitlab.example.com/api/v4'
          ENV['PRONTO_GITLAB_API_PRIVATE_TOKEN'] = 'token'
          ENV['CI_MERGE_REQUEST_IID'] = '10'

          ::Gitlab::Client.any_instance
            .should_receive(:merge_request_discussions)
            .with('prontolabs/pronto', 10)
            .once
            .and_return(paginated_response)

          subject
          subject
          subject
        end
      end
    end
  end
end
