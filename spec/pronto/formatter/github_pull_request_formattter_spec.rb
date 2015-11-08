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

        specify do
          ENV['PULL_REQUEST_ID'] = '10'

          Octokit::Client.any_instance
            .should_receive(:pull_comments)
            .once
            .and_return([])

          Octokit::Client.any_instance
            .should_receive(:create_pull_comment)
            .once

          subject
        end
      end
    end
  end
end
