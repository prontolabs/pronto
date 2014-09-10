require 'spec_helper'

module Pronto
  describe Github do
    let(:github) { Github.new }

    describe '#commit_comments' do
      subject { github.commit_comments(repo, sha) }

      context 'three requests for same comments' do
        let(:repo) { 'mmozuras/pronto' }
        let(:sha) { '61e4bef' }

        specify do
          Octokit::Client.any_instance
                         .should_receive(:commit_comments)
                         .once
                         .and_return([])

          subject
          subject
          subject
        end
      end
    end
  end
end
