module Pronto
  module Formatter
    describe GitlabMergeRequestReviewFormatter do
      ENV['PRONTO_GITLAB_API_ENDPOINT'] = 'http://example.com/api/v4'
      ENV['PRONTO_GITLAB_API_PRIVATE_TOKEN'] = 'token'
      ENV['CI_MERGE_REQUEST_IID'] = '1'

      let(:formatter) { described_class.new }
      let(:diff_refs) {
        double(diff_refs: {"base_sha"=>"8f38ee927a5ea1e7fcf91e2603f9a09a2f6ad8a7",
                           "head_sha"=>"4075991c8c9170e614f754aed3a52b25f4a586b4",
                           "start_sha"=>"8f38ee927a5ea1e7fcf91e2603f9a09a2f6ad8a7"})
      }

      describe '#format' do
        subject { formatter.format(messages, repo, nil) }
        let(:messages) { [message, message] }
        let(:repo) { Git::Repository.new('spec/fixtures/test.git') }
        let(:message) { Message.new('path/to', line, :warning, 'crucial') }
        let(:line) { double(line: double(new_lineno: 1), commit_sha: '123', position: nil) }
        let(:paginated_response) { double(auto_paginate: []) }
        before { line.stub(:commit_line).and_return(line) }

        specify do
          ::Gitlab::Client.any_instance
            .should_receive(:merge_request_discussions)
            .once
            .and_return(paginated_response)

          ::Gitlab::Client.any_instance
            .should_receive(:merge_request)
            .once
            .and_return(diff_refs)

          ::Gitlab::Client.any_instance
            .should_receive(:create_merge_request_discussion)
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
        let(:line1) { double(line: double(new_lineno: 1), commit_sha: '123', position: nil) }
        let(:line2) { double(line: double(new_lineno: 2), commit_sha: '123', position: nil) }
        let(:paginated_response) { double(auto_paginate: []) }
        before do
          line1.stub(:commit_line).and_return(line1)
          line2.stub(:commit_line).and_return(line2)
        end

        specify do
          ::Gitlab::Client.any_instance
            .should_receive(:merge_request_discussions)
            .once
            .and_return(paginated_response)

          ::Gitlab::Client.any_instance
            .should_receive(:merge_request)
            .once
            .and_return(diff_refs)

          ::Gitlab::Client.any_instance
            .should_receive(:create_merge_request_discussion)
            .twice

          subject
        end
      end
    end
  end
end
