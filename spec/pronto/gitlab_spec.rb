require 'spec_helper'

module Pronto
  describe Gitlab do
    let(:gitlab) { Gitlab.new(repo) }

    describe '#commit_comments' do
      subject { gitlab.commit_comments(sha) }

      context 'three requests for same comments' do
        let(:repo) { double(remote_urls: ['git@gitlab.example.com:mmozuras/pronto.git']) }
        let(:sha) { 'foobar' }
        let(:comment) { double(note: 'note', path: 'path', line: 1) }

        specify do
          ENV['GITLAB_API_ENDPOINT'] = 'http://gitlab.example.com/api/v3'
          ENV['GITLAB_API_PRIVATE_TOKEN'] = 'token'

          ::Gitlab::Client.any_instance
            .should_receive(:commit_comments)
            .with('mmozuras%2Fpronto', sha, per_page: 500)
            .once
            .and_return([comment])

          subject
          subject
          subject
        end
      end
    end
  end
end
