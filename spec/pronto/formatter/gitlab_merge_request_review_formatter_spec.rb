module Pronto
  module Formatter
    describe GitlabMergeRequestReviewFormatter do
      let(:formatter) { described_class.new }

      let(:repo) { Git::Repository.new('spec/fixtures/test.git') }

      describe '#format' do
        subject { formatter.format(messages, repo, patches) }
        let(:messages) { [message, message] }
        let(:message) { Message.new(patch.new_file_full_path, line, :info, '') }
        let(:patch) { repo.show_commit('64dadfd').first }
        let(:line) { patch.added_lines.first }
        let(:patches) { repo.diff('64dadfd^') }
        let(:paginated_response) { double(auto_paginate: [])}
        let(:merge_request) do
          double(
            iid: 10,
            source_branch: 'prontolabs/pronto',
            diff_refs: {
              "base_sha" => "c380d3ace",
              "head_sha" => "2be7ddb70",
              "start_sha" => "c380d3ace"
          })
        end
        let(:paginated_merge_requests) { double(auto_paginate: [merge_request]) }

        before do
          ENV['PRONTO_PULL_REQUEST_ID'] = '10'
          ::Gitlab::Client.any_instance
            .should_receive(:merge_request)
            .and_return(merge_request)

          ::Gitlab::Client.any_instance
            .should_receive(:merge_requests)
            .and_return(paginated_merge_requests)

          ::Gitlab::Client.any_instance
            .should_receive(:merge_request_discussions)
            .once
            .and_return(paginated_response)
        end

        specify do
          ::Gitlab::Client.any_instance
            .should_receive(:create_merge_request_discussion)
            .once

          subject
        end
      end
    end
  end
end
