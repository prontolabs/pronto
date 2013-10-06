require 'spec_helper'

module Rugged
  class Diff
    describe Patch do
      let(:diff) { repository.diff('26c74f4', 'c0e8106') }
      let(:patch) { diff.patches.last }

      describe '#new_file_full_path' do
        subject { patch.new_file_full_path.to_s }
        it { should end_with '/pronto/formatter/github_formattter_spec.rb' }
      end

      describe '#lines' do
        subject { patch.lines }
        its(:count) { should == 56 }
      end

      describe '#added_lines' do
        subject { patch.added_lines }
        its(:count) { should == 30 }
      end

      describe '#deleted_lines' do
        subject { patch.deleted_lines }
        its(:count) { should == 11 }
      end
    end
  end
end
