require 'spec_helper'

module Pronto
  module Git
    describe Patches do
      describe '#find_line' do
        subject { Patches.new(repo, commit, patches).find_line(path, line) }

        let(:repo) { nil }
        let(:commit) { nil }

        let(:path) { '/test.rb' }
        let(:line) { 1 }

        context 'no patches' do
          let(:patches) { [] }
          it { should be_nil }
        end
      end
    end
  end
end
