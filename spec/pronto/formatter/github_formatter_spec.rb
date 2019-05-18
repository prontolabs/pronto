module Pronto
  module Formatter
    describe GithubFormatter do
      let(:formatter) { described_class.new }

      describe '#format' do
        subject { formatter.format(messages, repo, nil) }

        let(:repo) { Git::Repository.new('spec/fixtures/test.git') }
        let(:published_comments_msg) { "%{count} Pronto messages posted to #{formatter.pretty_name}" }

        context 'with duplicates' do
          let(:messages) { [message, message] }
          let(:message) { Message.new('path/to', line, :warning, 'crucial') }
          let(:line) { double(new_lineno: 1, commit_sha: '123', position: nil) }
          before { line.stub(:commit_line).and_return(line) }

          specify do
            Octokit::Client.any_instance
              .should_receive(:commit_comments)
              .once
              .and_return([])

            Octokit::Client.any_instance
              .should_receive(:create_commit_comment)
              .once

            subject.should eq format(published_comments_msg, count: 1)
          end
        end

        context 'without duplicates' do
          let(:messages) { [message1, message2] }
          let(:message1) { Message.new('path/to1', line1, :warning, 'crucial') }
          let(:message2) { Message.new('path/to2', line2, :warning, 'crucial') }
          let(:line1) { double(new_lineno: 1, commit_sha: '123', position: nil) }
          let(:line2) { double(new_lineno: 2, commit_sha: '123', position: nil) }

          before do
            line1.stub(:commit_line).and_return(line1)
            line2.stub(:commit_line).and_return(line2)
          end

          specify do
            Octokit::Client.any_instance
              .should_receive(:commit_comments)
              .once
              .and_return([])

            Octokit::Client.any_instance
              .should_receive(:create_commit_comment)
              .twice

            subject.should eq format(published_comments_msg, count: 2)
          end
        end
      end
    end
  end
end
