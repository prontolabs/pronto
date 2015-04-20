require 'spec_helper'

module Pronto
  describe Github do
    let(:github) { Github.new(repo) }

    describe '#commit_comments' do
      subject { github.commit_comments(sha) }

      context 'three requests for same comments' do
        let(:repo) do
          double(remote_urls: ['git@github.com:mmozuras/pronto.git'])
        end
        let(:sha) { '61e4bef' }

        specify do
          Octokit::Client.any_instance
            .should_receive(:commit_comments)
            .with('mmozuras/pronto', sha)
            .once
            .and_return([])

          subject
          subject
          subject
        end
      end
    end

    describe '#pull_comments' do
      subject { github.pull_comments(sha) }

      context 'three requests for same comments' do
        let(:repo) do
          double(remote_urls: ['https://github.com/mmozuras/pronto.git'])
        end
        let(:sha) { '61e4bef' }

        specify do
          Octokit::Client.any_instance
            .should_receive(:pull_comments)
            .with('mmozuras/pronto', 10)
            .once
            .and_return([])

          ENV['PULL_REQUEST_ID'] = '10'

          subject
          subject
          subject
        end
      end
    end
  end
end
