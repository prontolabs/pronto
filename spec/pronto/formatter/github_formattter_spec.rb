require 'spec_helper'

module Pronto
  module Formatter
    describe GithubFormatter do
      let(:github_formatter) { GithubFormatter.new }

      describe '#format' do
        subject { github_formatter.format(messages, repository) }
        let(:messages) { [message, message] }
        let(:repository) { Pronto::Git::Repository.new('.') }
        let(:message) { Message.new('path/to', line, :warning, 'crucial') }
        let(:line) { double(new_lineno: 1, commit_sha: '123', position: nil) }
        before { line.stub(:commit_line).and_return(line) }

        specify do
          Octokit::Client.any_instance
                         .should_receive(:commit_comments)
                         .twice
                         .and_return([])

          Octokit::Client.any_instance
                         .should_receive(:create_commit_comment)
                         .twice

          subject
        end
      end
    end
  end
end
