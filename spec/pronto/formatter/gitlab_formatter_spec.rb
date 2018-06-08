module Pronto
  module Formatter
    describe GitlabFormatter do
      ENV['PRONTO_GITLAB_API_ENDPOINT'] = 'http://example.com/api/v4'
      ENV['PRONTO_GITLAB_API_PRIVATE_TOKEN'] = 'token'

      let(:formatter) { described_class.new }

      describe '#format' do
        subject { formatter.format(messages, repo, nil) }
        let(:messages) { [message, message] }
        let(:repo) { Git::Repository.new('spec/fixtures/test.git') }
        let(:message) { Message.new('path/to', line, :warning, 'crucial') }
        let(:line) { double(new_lineno: 1, commit_sha: '123', position: nil) }
        before { line.stub(:commit_line).and_return(line) }

        specify do
          ::Gitlab::Client.any_instance
            .should_receive(:commit_comments)
            .once
            .and_return([])

          ::Gitlab::Client.any_instance
            .should_receive(:create_commit_comment)
            .once

          subject
        end
      end

      describe '#format without duplicates' do
        subject { formatter.format(messages, repo, nil) }
        let(:messages) { [message1, message2] }
        let(:repo) { Git::Repository.new('spec/fixtures/test.git') }
        let(:message1) { Message.new('path/to1', line1, :warning, 'crucial') }
        let(:message2) { Message.new('path/to2', line2, :warning, 'crucial') }
        let(:line1) { double(new_lineno: 1, commit_sha: '123', position: nil) }
        let(:line2) { double(new_lineno: 2, commit_sha: '123', position: nil) }
        before do
          line1.stub(:commit_line).and_return(line1)
          line2.stub(:commit_line).and_return(line2)
        end

        specify do
          ::Gitlab::Client.any_instance
            .should_receive(:commit_comments)
            .once
            .and_return([])

          ::Gitlab::Client.any_instance
            .should_receive(:create_commit_comment)
            .twice

          subject
        end
      end
    end
  end
end
