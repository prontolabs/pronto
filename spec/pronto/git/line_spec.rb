require 'spec_helper'

module Pronto
  module Git
    describe Line do
      let(:diff) { repository.diff('88558b7', '88558b7~5') }
      let(:patch) { Patch.new(diff.patches.last, repository) }
      let(:line) { patch.lines[2] }

      describe '#position' do
        subject { line.position }
        it { should == 3 }
      end
    end
  end
end
