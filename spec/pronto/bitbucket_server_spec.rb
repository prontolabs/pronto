module Pronto
  describe BitbucketServer do
    let(:bitbucket) { described_class.new(repo) }

    let(:repo) do
      double(remote_urls: ['git@bitbucket.org:mmozuras/pronto.git'],
             branch: nil)
    end
    let(:sha) { '61e4bef' }

    describe '#pull_comments' do
      subject { bitbucket.pull_comments(sha) }

      let(:response) do
        {
          comment: {
            text: 'text'
          },
          commentAnchor: {
            path: '/path',
            line: '1'
          }
        }
      end

      context 'three requests for same comments' do
        specify do
          BitbucketServerClient.any_instance
            .should_receive(:pull_requests)
            .once
            .and_return([])

          BitbucketServerClient.any_instance
            .should_receive(:pull_comments)
            .with('mmozuras/pronto', 10)
            .once
            .and_return([response])

          ENV['PRONTO_PULL_REQUEST_ID'] = '10'

          subject
          subject
          subject
        end
      end
    end
  end
end
