require 'spec_helper'

module Rugged
  class Diff
    describe Line do
      let(:diff) { repository.diff('52637a1', '52637a1~5') }
      let(:patch) { diff.patches.last }
      let(:line) { patch.lines[2] }

      describe '#position' do
        subject { line.position }
        it { should == 3 }
      end
    end
  end
end
