module Pronto
  describe Github do
    let(:github) { described_class.new(repo) }
    let(:repo) { double(remote_urls: ssh_remote_urls, branch: nil, head_detached?: false) }
    let(:ssh_remote_urls) { ["git@github.com:#{github_slug}.git"] }
    let(:github_slug) { 'prontolabs/pronto' }
    let(:sha) { '61e4bef' }
    let(:comment) { double(body: 'note', path: 'path', line: 1, position: 1) }
    let(:empty_client_options) do
      {
        event: 'COMMENT'
      }
    end

    before { ENV.stub(:[]) }

    describe '#commit_comments' do
      subject { github.commit_comments(sha) }

      context 'three requests for same comments' do
        specify do
          Octokit::Client.any_instance
            .should_receive(:commit_comments)
            .with(github_slug, sha)
            .once
            .and_return([comment])

          subject
          subject
          subject
        end
      end

      context 'git remote without .git suffix' do
        let(:repo) { double(remote_urls: ssh_remote_urls) }

        specify do
          Octokit::Client.any_instance
            .should_receive(:commit_comments)
            .with(github_slug, sha)
            .once
            .and_return([comment])

          subject
        end
      end
    end

    describe '#pull_comments' do
      subject { github.pull_comments(sha) }

      before { ENV.stub(:[]).with('PRONTO_PULL_REQUEST_ID').and_return(10) }

      context 'three requests for same comments' do
        specify do
          Octokit::Client.any_instance
            .should_receive(:pull_comments)
            .with(github_slug, 10)
            .once
            .and_return([comment])

          3.times { subject }
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
          .with(github_slug, expected_sha, state, context:     context,
                                                  description: desc)
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

    describe '#publish_pull_request_comments' do
      subject { github.publish_pull_request_comments(comments) }

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

      context 'with comments and' do
        before do
          github.stub(:pull_id).and_return(pull_id)
          config.stub(:warnings_per_review).and_return(warnings_per_review)
        end

        let(:pull_id) { 10 }
        let(:config)  { github.instance_variable_get(:@config) }
        let(:comments) do
          [
            double(path: 'bad_file.rb', position: 10, body: 'Offense #1'),
            double(path: 'bad_file.rb', position: 20, body: 'Offense #2')
          ]
        end
        let(:options) do
          empty_client_options
            .merge(comments: [{ path: 'bad_file.rb', line: 10, body: 'Offense #1' },
                              { path: 'bad_file.rb', line: 20, body: 'Offense #2' }])
        end

        {
          equal: 2,
          more_than: 5
        }.each do |condition, warnings_per_review|
          context "when warnings per review #{condition} total comments" do
            let(:warnings_per_review) { warnings_per_review }

            specify do
              octokit_client
                .should_receive(:create_pull_request_review)
                .with(github_slug, pull_id, options)
                .once

              subject
            end
          end
        end

        context 'when warnings per review are lower than comments' do

          let(:warnings_per_review) { 1 }
          let(:first_options) do
            empty_client_options
              .merge(comments: [{ path: 'bad_file.rb', line: 10, body: 'Offense #1' }])
          end
          let(:second_options) do
            empty_client_options
              .merge(comments: [{ path: 'bad_file.rb', line: 20, body: 'Offense #2' }])
          end

          specify do
            octokit_client
              .should_receive(:create_pull_request_review)
              .with(github_slug, pull_id, first_options)
              .once
            octokit_client
              .should_receive(:create_pull_request_review)
              .with(github_slug, pull_id, second_options)
              .once

            subject
          end
        end
      end
    end
  end
end
