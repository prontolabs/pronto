module Pronto
  describe Gitlab do
    let(:gitlab) { described_class.new(repo) }
    before do
      ENV['PRONTO_GITLAB_API_ENDPOINT'] = 'http://gitlab.example.com/api/v4'
      ENV['PRONTO_GITLAB_API_PRIVATE_TOKEN'] = 'token'
      ENV['PRONTO_PULL_REQUEST_ID'] = nil
    end
    let(:repo) do
      double(remote_urls: ['git@gitlab.example.com:prontolabs/pronto.git'], branch: 'prontolabs/pronto')
    end

    describe '#position_sha' do
      subject { gitlab.send(:position_sha) }
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

    describe '#mr_id' do
      it 'should return iid of merge request if there is one' do
        gitlab.should_receive(:merge_request).twice.and_return(double(iid: 10))
        gitlab.send(:mr_id).should eql(10)
      end

      it 'should return the env_pull_id if no pull' do
        gitlab.should_receive(:merge_request).and_return(nil)
        gitlab.should_receive(:env_pull_id).and_return(11)
        gitlab.send(:mr_id).should eql(11)
      end
    end

    describe '#merge_request' do
      subject { gitlab.send(:merge_request) }
      it 'should return merge request for env_pull_id if specified' do
        gitlab.should_receive(:env_pull_id).twice.and_return(11)
        gitlab.should_receive(:merge_request_by_id).with(11)

        subject
      end

      it 'should return merge_request_for_branch if repo has branch' do
        gitlab.should_receive(:env_pull_id).and_return(nil)
        gitlab.should_receive(:merge_request_by_branch).with('prontolabs/pronto')

        subject
      end

      it 'should find by commit if no branch' do
        gitlab.should_receive(:env_pull_id).and_return(nil)
        repo.should_receive(:branch).and_return(nil)
        repo.should_receive(:head_detached?).and_return(true)
        repo.should_receive(:head_commit_sha).and_return('abcdefg')
        gitlab.should_receive(:merge_request_by_commit).with('abcdefg')

        subject
      end
    end

    describe '#commit_comments' do
      subject { gitlab.commit_comments(sha) }

      context 'three requests for same comments' do
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

    describe '#create_merge_request_review' do
      subject { gitlab.create_merge_request_review(comments) }

      context 'no comments' do
        let(:comments) { [] }
        specify do
          ::Gitlab::Client.any_instance
            .should_not_receive(:create_merge_request_discussion)
          subject
        end
      end

      context 'with comments' do
        let(:comments) { [comment] }
        let(:comment) { double(body: 'body', path: 'path', position: 1) }
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

          ::Gitlab::Client.any_instance
            .should_receive(:create_merge_request_discussion)
            .with('prontolabs/pronto', 10, {:body=>"body",
              :position=>{"base_sha"=>"c380d3ace", "head_sha"=>"2be7ddb70",
                :new_line=>1, :new_path=>"path", :old_line=>nil,
                :position_type=>"text",
                "start_sha"=>"c380d3ace"}})

          subject
        end
      end
    end
  end
end
