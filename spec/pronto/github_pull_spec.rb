module Pronto
  describe GithubPull do
    let(:github_pull) { described_class.new(octokit_client, slug) }
    let(:slug) { 'prontolabs/pronto' }
    let(:octokit_client) { double(Octokit::Client) }

    before do
      github_pull.instance_variable_set(:@client, octokit_client)
    end

    describe '#pull_by_id' do
      subject { github_pull.pull_by_id(10) }

      context 'pull request exists' do
        let(:pull) { { number: 10, head: { sha: 123_456 } } }
        specify do
          octokit_client
            .should_receive(:pull_requests)
            .once
            .and_return([pull])

          subject.should eq(pull)
        end
      end

      context 'pull request does not exist' do
        specify do
          octokit_client
            .should_receive(:pull_requests)
            .once
            .and_return([])

          -> { subject }.should raise_error(Pronto::Error, /Pull request ##{10}/)
        end
      end
    end

    describe '#pull_by_branch' do
      let(:branch) { 'awesome_branch' }

      context 'branch exists' do
        subject { github_pull.pull_by_branch(branch) }
        let(:pull) { { head: { ref: branch } } }
        specify do
          octokit_client
            .should_receive(:pull_requests)
            .once
            .and_return([pull])

          subject.should eq(pull)
        end
      end

      context 'branch does not exist' do
        subject { github_pull.pull_by_branch(branch) }
        specify do
          octokit_client
            .should_receive(:pull_requests)
            .once
            .and_return([])

          -> { subject }.should raise_error(Pronto::Error, /#{branch}/)
        end
      end
    end

    describe '#pull_by_commit' do
      let(:sha) { 'a6fmk32' }

      context 'commit exists' do
        subject { github_pull.pull_by_commit(sha) }
        let(:pull) { { head: { sha: sha } } }
        specify do
          octokit_client
            .should_receive(:pull_requests)
            .once
            .and_return([pull])

          subject.should eq(pull)
        end
      end

      context 'commit does not exist' do
        subject { github_pull.pull_by_commit(sha) }
        specify do
          octokit_client
            .should_receive(:pull_requests)
            .once
            .and_return([])

          -> { subject }.should raise_error(Pronto::Error, /#{sha}/)
        end
      end
    end
  end
end
