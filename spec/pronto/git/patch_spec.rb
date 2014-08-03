require 'spec_helper'

module Pronto
  module Git
    describe Patch do
      let(:patch) { Patch.new(rugged_patch, repo) }

      let(:repo) { nil }

      describe '#additions' do
        subject { patch.additions }

        let(:rugged_patch) { double(stat: [15, 13]) }
        it { should == 15 }
      end

      describe '#deletions' do
        subject { patch.deletions }

        let(:rugged_patch) { double(stat: [5, 17]) }
        it { should == 17 }
      end
    end
  end
end
