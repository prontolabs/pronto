require 'spec_helper'

module Rugged
  describe Remote do
    let(:repository) { Repository.init_at('.') }
    let(:remote) { Remote.new(repository, url) }

    describe '#github_slug' do
      subject { remote.github_slug }

      context 'ssh' do
        let(:url) { 'git@github.com:mmozuras/pronto.git' }
        it { should == 'mmozuras/pronto' }
      end

      context 'http' do
        let(:url) { 'https://github.com/mmozuras/pronto.git' }
        it { should == 'mmozuras/pronto' }
      end
    end
  end
end
