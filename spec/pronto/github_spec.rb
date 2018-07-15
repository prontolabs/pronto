module Pronto
  describe Github do
    let(:github) { described_class.new(repo) }

    let(:repo) do
      double(remote_urls: ['git@github.com:prontolabs/pronto.git'], branch: nil, head_detached?: false)
    end
    let(:sha) { '61e4bef' }
    let(:comment) { double(body: 'note', path: 'path', line: 1, position: 1) }
    before do
      ENV.stub(:[])
    end

    describe '#commit_comments' do
      subject { github.commit_comments(sha) }

      context 'three requests for same comments' do
        specify do
          Octokit::Client.any_instance
            .should_receive(:commit_comments)
            .with('prontolabs/pronto', sha)
            .once
            .and_return([comment])

          subject
          subject
          subject
        end
      end

      context 'git remote without .git suffix' do
        let(:repo) { double(remote_urls: ['git@github.com:prontolabs/pronto']) }

        specify do
          Octokit::Client.any_instance
            .should_receive(:commit_comments)
            .with('prontolabs/pronto', sha)
            .once
            .and_return([comment])

          subject
        end
      end
    end

    describe '#pull_comments' do
      subject { github.pull_comments(sha) }
      before do
        ENV.stub(:[]).with('PRONTO_PULL_REQUEST_ID').and_return(10)
      end

      context 'three requests for same comments' do
        specify do
          Octokit::Client.any_instance
            .should_receive(:pull_comments)
            .with('prontolabs/pronto', 10)
            .once
            .and_return([comment])

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
      let(:github_pull) { double(GithubPull) }
      let(:status) { Status.new(sha, state, context, desc) }
      let(:state) { :success }
      let(:context) { :pronto }
      let(:desc) { 'No issues found!' }

      before do
        github.instance_variable_set(:@client, octokit_client)
        github.instance_variable_set(:@github_pull, github_pull)

        octokit_client
          .should_receive(:create_status)
          .with('prontolabs/pronto', expected_sha, state,
                context: context, description: desc)
          .once
      end

      context 'uses PRONTO_PULL_REQUEST_ID to create commit status' do
        let(:pull_request_sha) { '123456' }
        let(:expected_sha) { pull_request_sha }

        specify do
          ENV.stub(:[]).with('PRONTO_PULL_REQUEST_ID').and_return(10)
          github_pull
            .should_receive(:pull_by_id)
            .with(10)
            .once
            .and_return(head: { sha: pull_request_sha })

          subject
        end
      end

      context 'adds status to commit with sha' do
        let(:expected_sha) { sha }

        specify do
          octokit_client.should_not_receive(:pull_requests)

          subject
        end
      end
    end

    describe '#create_pull_request_review' do
      subject { github.create_pull_request_review(comments) }

      let(:octokit_client) { double(Octokit::Client) }

      before do
        github.instance_variable_set(:@client, octokit_client)
      end

      context 'with no comments' do
        let(:comments) { [] }

        specify do
          octokit_client.should_not_receive(:create_pull_request_review)
          subject
        end
      end

      context 'with comments' do
        before do
          github.should_receive(:pull_id).once.and_return(pull_id)
        end

        let(:pull_id) { 10 }
        let(:comments) do
          [
            double(path: 'bad_file.rb', position: 10, body: 'Offense #1'),
            double(path: 'bad_file.rb', position: 20, body: 'Offense #2')
          ]
        end
        let(:options) do
          {
            event: 'COMMENT',
            accept: 'application/vnd.github.black-cat-preview+json',
            comments: [
              { path: 'bad_file.rb', position: 10, body: 'Offense #1' },
              { path: 'bad_file.rb', position: 20, body: 'Offense #2' }
            ]
          }
        end

        specify do
          octokit_client
            .should_not_receive(:create_pull_request_review)
            .with('prontolabs/pronto', pull_id, options)
            .once

          subject
        end
      end

      context 'pull request for detached head does not exist' do
        let(:comments) do
          [double(path: 'bad_file.rb', position: 10, body: 'Offense #1')]
        end
        let(:repo) do
          double(remote_urls: ['git@github.com:prontolabs/pronto'],
                 branch: nil,
                 head_detached?: true,
                 head_commit_sha: 'sha_with_no_pr')
        end
        specify do
          octokit_client.should_not_receive(:create_pull_request_review)

          -> { subject }.should raise_error(Pronto::Error, /sha_with_no_pr/)
        end
      end
    end
  end
end
