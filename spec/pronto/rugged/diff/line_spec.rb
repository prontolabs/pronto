require 'spec_helper'

module Rugged
  class Diff
    describe Line do
      let(:diff) { repository.diff('26c74f4', 'c0e8106') }
      let(:patch) { diff.patches.last }
      let(:line) { patch.lines[20] }

      describe '#position' do
        subject { line.position }
        it { should == 22 }
      end
    end
  end
end
