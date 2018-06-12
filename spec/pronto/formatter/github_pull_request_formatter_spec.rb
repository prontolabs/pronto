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

        before do
          ENV['PRONTO_PULL_REQUEST_ID'] = '10'
          Octokit::Client.any_instance
            .should_receive(:pull_requests)
            .once
            .and_return([{ number: 10, head: { sha: 'foo' } }])

          Octokit::Client.any_instance
            .should_receive(:pull_comments)
            .once
            .and_return([])
        end

        specify do
          Octokit::Client.any_instance
            .should_receive(:create_pull_comment)
            .once

          subject
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
            Octokit::Client.any_instance
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
