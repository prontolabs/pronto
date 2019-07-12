module Pronto
  describe Gitlab do
    let(:gitlab) { described_class.new(repo) }

    describe '#position_sha' do
      subject { gitlab.send(:position_sha) }
      let(:repo) do
        double(remote_urls: ['git@gitlab.example.com:prontolabs/pronto.git'], branch: 'prontolabs/pronto')
      end
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

      specify do
        ::Gitlab::Client.any_instance
          .should_receive(:merge_requests)
          .and_return(paginated_merge_requests)
        ::Gitlab::Client.any_instance
            .should_receive(:merge_request)
            .with('prontolabs/pronto', 10)
            .once
            .and_return(merge_request)

        subject
      end
    end

    describe '#slug' do
      subject { gitlab.send(:slug) }
      before(:each) do
        ENV['PRONTO_GITLAB_API_ENDPOINT'] = 'http://gitlab.example.com/api/v4'
        ENV['PRONTO_GITLAB_API_PRIVATE_TOKEN'] = 'token'
      end

      context 'ssh with port remote url' do
        let(:repo) do
          remote_url = 'ssh://git@gitlab.example.com:111/prontolabs/pronto.git'
          double(remote_urls: [remote_url])
        end

        it 'returns correct slug' do
          subject.should eql('prontolabs/pronto')
        end
      end

      context 'git remote url' do
        let(:repo) do
          double(remote_urls: ['git@gitlab.example.com:prontolabs/pronto.git'])
        end

        it 'returns correct slug' do
          subject.should eql('prontolabs/pronto')
        end
      end
    end

    describe '#commit_comments' do
      subject { gitlab.commit_comments(sha) }

      context 'three requests for same comments' do
        let(:repo) do
          double(remote_urls: ['git@gitlab.example.com:prontolabs/pronto.git'])
        end
        let(:sha) { 'foobar' }
        let(:comment) { double(note: 'body', path: 'path', line: 1) }
        let(:paginated_response) { double(auto_paginate: [ comment ]) }

        specify do
          ::Gitlab::Client.any_instance
            .should_receive(:commit_comments)
            .with('prontolabs/pronto', sha)
            .once
            .and_return(paginated_response)

          Comment.should_receive(:new)
            .with(sha, comment.note, comment.path, comment.line)
            .once

          subject
          subject
          subject
        end
      end
    end

    describe '#pull_comments' do
      subject { gitlab.pull_comments(sha) }

      context 'three requests for same comments' do
        let(:repo) do
          double(remote_urls: ['git@gitlab.example.com:prontolabs/pronto.git'], branch: 'prontolabs/pronto')
        end
        let(:sha) { 'foobar' }
        let(:merge_request) { double(source_branch: 'prontolabs/pronto', iid: 10) }
        let(:comment) { double(notes: [{ 'body' => 'body', 'position' => { 'new_path' => 'path', 'new_line'=> 1 } }]) }
        let(:paginated_response) { double(auto_paginate: [ comment ]) }
        let(:merge_request) { double(source_branch: 'prontolabs/pronto', iid: 10) }
        let(:paginated_merge_requests) { double(auto_paginate: [merge_request]) }

        specify do
          ::Gitlab::Client.any_instance
            .should_receive(:merge_requests)
            .and_return(paginated_merge_requests)

          ::Gitlab::Client.any_instance
            .should_receive(:merge_request_discussions)
            .with('prontolabs/pronto', merge_request.iid)
            .once
            .and_return(paginated_response)

          note = comment.notes.first
          Comment.should_receive(:new)
            .with(
              sha,
              note['body'],
              note['position']['new_path'],
              note['position']['new_line']
            ).once

          subject
          subject
          subject
        end
      end
    end
  end
end
