require 'spec_helper'

module Pronto
  module Git
    describe Remote do
      let(:remote) { Remote.new(double(url: url)) }

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
end
