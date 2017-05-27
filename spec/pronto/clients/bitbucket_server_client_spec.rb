module Pronto
  describe BitbucketServerClient do
    let(:client) { described_class.new('username', 'password', 'endpoint') }

    describe '#create_pull_comment' do
      subject { client.create_pull_comment(slug, sha, body, path, position) }
      let(:slug) { 'prontolabs/pronto' }
      let(:sha) { '123' }
      let(:body) { 'comment' }
      let(:path) { 'path/to/file' }
      let(:position) { 1 }

      context 'success' do
        before { BitbucketServerClient.stub(:post).and_return(response) }
        let(:response) { double('Response', success?: true) }
        its(:success?) { should be_truthy }
      end
    end
  end
end
