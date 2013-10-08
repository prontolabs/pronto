require 'spec_helper'

module Rugged
  class Diff
    describe Patch do
      let(:diff) { repository.diff('52637a1', '52637a1~5') }
      let(:patch) { diff.patches.last }

      describe '#new_file_full_path' do
        subject { patch.new_file_full_path.to_s }
        it { should end_with '/pronto/formatter/github_formattter_spec.rb' }
      end

      describe '#lines' do
        subject { patch.lines }
        its(:count) { should == 7 }
      end

      describe '#added_lines' do
        subject { patch.added_lines }
        its(:count) { should == 0 }
      end

      describe '#deleted_lines' do
        subject { patch.deleted_lines }
        its(:count) { should == 1 }
      end
    end
  end
end
