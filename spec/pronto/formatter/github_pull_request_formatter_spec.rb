module Pronto
  module Formatter
    describe GithubPullRequestFormatter do
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
          octokit_client
            .stub(:pull_requests)
            .once
            .and_return([{ number: 10, head: { sha: 'foo' } }])

          octokit_client
            .stub(:pull_comments)
            .once
            .and_return([double(body: 'a comment', path: 'a/path', line: 5)])
        end

        specify do
          octokit_client
            .should_receive(:create_pull_comment)
            .once

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

            octokit_client.should_not_receive(:create_pull_comment)

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

            octokit_client.should_receive(:create_pull_comment).once

            subject.should eq '1 Pronto messages posted to GitHub (1 existing)'
          end
        end

        context 'error handling' do
          let(:error_response) do
            {
              status: 422,
              body: {
                message: 'Validation Failed',
                errors: [
                  resource: 'Issue',
                  field: 'title',
                  code: 'missing_field'
                ]
              }.to_json,
              response_headers: {
                content_type: 'json'
              }
            }
          end

          it 'handles and prints details' do
            error = Octokit::UnprocessableEntity.from_response(error_response)
            octokit_client
              .should_receive(:create_pull_comment)
              .and_raise(error)

            $stderr.should_receive(:puts) do |line|
              line.should =~ /Failed to post/
              line.should =~ /Validation Failed/
              line.should =~ /missing_field/
              line.should =~ /Issue/
            end
            subject
          end
        end
      end
    end
  end
end
