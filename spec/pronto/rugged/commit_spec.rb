require 'spec_helper'

module Rugged
  describe Commit do
    let(:commit) { repository.lookup(repository.head.target) }

    describe '#show' do
      subject { commit.show }
      its(:patch) { should == repository.diff('HEAD', 'HEAD~1').patch }
    end
  end
end
