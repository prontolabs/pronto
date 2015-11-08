module Pronto
  describe Github do
    let(:github) { described_class.new(repo) }

    let(:repo) { double(remote_urls: ['git@github.com:mmozuras/pronto.git']) }
    let(:sha) { '61e4bef' }
    let(:comment) { double(body: 'note', path: 'path', line: 1, position: 1) }

    describe '#slug' do
      let(:repo) { double(remote_urls: ['git@github.com:mmozuras/pronto']) }
      subject { github.commit_comments(sha) }

      context 'git remote without .git suffix' do
        specify do
          Octokit::Client.any_instance
            .should_receive(:commit_comments)
            .with('mmozuras/pronto', sha)
            .once
            .and_return([comment])

          subject
        end
      end
    end

    describe '#commit_comments' do
      subject { github.commit_comments(sha) }

      context 'three requests for same comments' do
        specify do
          Octokit::Client.any_instance
            .should_receive(:commit_comments)
            .with('mmozuras/pronto', sha)
            .once
            .and_return([comment])

          subject
          subject
          subject
        end
      end
    end

    describe '#pull_comments' do
      subject { github.pull_comments(sha) }

      context 'three requests for same comments' do
        specify do
          Octokit::Client.any_instance
            .should_receive(:pull_comments)
            .with('mmozuras/pronto', 10)
            .once
            .and_return([comment])

          ENV['PULL_REQUEST_ID'] = '10'

          subject
          subject
          subject
        end
      end
    end
  end
end
