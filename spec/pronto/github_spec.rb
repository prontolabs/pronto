module Pronto
  describe Github do
    let(:github) { described_class.new(repo) }

    let(:repo) do
      double(remote_urls: ['git@github.com:mmozuras/pronto.git'], branch: nil)
    end
    let(:sha) { '61e4bef' }
    let(:comment) { double(body: 'note', path: 'path', line: 1, position: 1) }

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

      context 'git remote without .git suffix' do
        let(:repo) { double(remote_urls: ['git@github.com:mmozuras/pronto']) }

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

    describe '#pull_comments' do
      subject { github.pull_comments(sha) }

      context 'three requests for same comments' do
        specify do
          Octokit::Client.any_instance
            .should_receive(:pull_requests)
            .once
            .and_return([])

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

      context 'pull request does not exist' do
        specify do
          Octokit::Client.any_instance
            .should_receive(:pull_comments)
            .and_raise(Octokit::NotFound)

          -> { subject }.should raise_error(Pronto::Error)
        end
      end
    end

    describe '#create_commit_status' do
      subject { github.create_commit_status(status) }

      let(:octokit_client) { double(Octokit::Client) }
      let(:status) { Status.new(sha, state, context, desc) }
      let(:state) { :success }
      let(:context) { :pronto }
      let(:desc) { 'No issues found!' }

      before do
        github.instance_variable_set(:@client, octokit_client)

        octokit_client
          .should_receive(:create_status)
          .with('mmozuras/pronto', expected_sha, state,
                context: context, description: desc)
          .once
      end
      after { ENV.delete('PULL_REQUEST_ID') }

      context 'uses PULL_REQUEST_ID to create commit status' do
        let(:pull_request_sha) { '123456' }
        let(:expected_sha) { pull_request_sha }

        before { ENV['PULL_REQUEST_ID'] = '10' }

        specify do
          octokit_client
            .should_receive(:pull_requests)
            .once
            .and_return([{ number: 10, head: { sha: pull_request_sha } }])

          subject
        end
      end

      context 'adds status to commit with sha' do
        let(:expected_sha) { sha }

        before { ENV.delete('PULL_REQUEST_ID') }

        specify do
          octokit_client
            .should_not_receive(:pull_requests)

          subject
        end
      end
    end
  end
end
