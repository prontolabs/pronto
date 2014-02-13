require 'spec_helper'

module Rugged
  class Diff
    describe Patch do
      let(:diff) { repository.diff('88558b7', '88558b7~5') }
      let(:patch) { diff.patches.last }

      describe '#new_file_full_path' do
        subject { patch.new_file_full_path.to_s }
        it { should end_with '/pronto/spec/pronto/rugged/diff/patch_spec.rb' }
      end

      describe '#lines' do
        subject { patch.lines }
        its(:count) { should == 28 }
      end

      describe '#added_lines' do
        subject { patch.added_lines }
        its(:count) { should == 4 }
      end

      describe '#deleted_lines' do
        subject { patch.deleted_lines }
        its(:count) { should == 4 }
      end
    end
  end
end
