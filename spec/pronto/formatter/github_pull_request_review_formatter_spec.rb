module Pronto
  module Formatter
    describe GithubPullRequestReviewFormatter do
      let(:formatter) { described_class.new }

      let(:repo) { Git::Repository.new('spec/fixtures/test.git') }

      describe '#format' do
        subject { formatter.format(messages, repo, patches) }
        let(:messages) { [message, message] }
        let(:message) { Message.new(patch.new_file_full_path, line, :info, '') }
        let(:patch) { repo.show_commit('64dadfd').first }
        let(:line) { patch.added_lines.first }
        let(:patches) { repo.diff('64dadfd^') }
        let(:octokit_client) { instance_double(Octokit::Client) }

        before do
          ENV['PRONTO_PULL_REQUEST_ID'] = '10'
          Octokit::Client.stub(:new).and_return(octokit_client)
        end

        specify do
          octokit_client.should_receive(:pull_comments).and_return([])
          octokit_client.should_receive(:create_pull_request_review).once

          subject
        end

        context 'with duplicate comment' do
          let(:messages) { [message] }
          let(:message) { Message.new('path/to', line, :warning, 'existed') }
          let(:line) { double(new_lineno: 3, commit_sha: '123', position: 3) }

          specify do
            octokit_client.should_receive(:pull_comments).and_return(
              [double(body: 'existed', path: 'path/to', line: line.new_lineno)]
            )

            octokit_client.should_not_receive(:create_pull_request_review)

            subject.should eq '0 Pronto messages posted to GitHub (1 existing)'
          end
        end

        context 'with one duplicate and one non duplicated comment' do
          let(:messages) { [message, existing_message] }
          let(:message) { Message.new('path/to', line, :warning, 'crucial') }
          let(:existing_message) { Message.new('path/to', line, :warning, 'existed') }

          specify do
            octokit_client.should_receive(:pull_comments).and_return(
              [double(body: 'existed', path: 'path/to', line: line.new_lineno)]
            )

            octokit_client.should_receive(:create_pull_request_review).once

            subject.should eq '1 Pronto messages posted to GitHub (1 existing)'
          end
        end
      end
    end
  end
end
