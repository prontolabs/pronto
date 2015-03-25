require 'spec_helper'

describe Pronto do
  let(:repo) { Pronto::Git::Repository.new('spec/fixtures/test.git') }

  describe '#path' do
    subject { repo.path }
    its(:to_s) { should end_with 'pronto/spec/fixtures' }
  end

  describe '#branch' do
    subject { repo.branch }
    it { should == 'master' }
  end

  describe '#remote_urls' do
    subject { repo.remote_urls }
    it { should be_empty }
  end
end
