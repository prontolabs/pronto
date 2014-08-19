require 'spec_helper'

module Pronto
  module Formatter
    describe '.get' do
      subject { Formatter.get(name) }

      context 'github' do
        let(:name) { 'github' }
        it { should be_an_instance_of GithubFormatter }
      end

      context 'github_pr' do
        let(:name) { 'github_pr' }
        it { should be_an_instance_of GithubPullRequestFormatter }
      end

      context 'json' do
        let(:name) { 'json' }
        it { should be_an_instance_of JsonFormatter }
      end

      context 'text' do
        let(:name) { 'text' }
        it { should be_an_instance_of TextFormatter }
      end

      context 'checkstyle' do
        let(:name) { 'checkstyle' }
        it { should be_an_instance_of CheckstyleFormatter }
      end

      context 'empty' do
        let(:name) { '' }
        it { should be_an_instance_of TextFormatter }
      end

      context 'nil' do
        let(:name) { nil }
        it { should be_an_instance_of TextFormatter }
      end
    end

    describe '.names' do
      subject { Formatter.names }
      it { should =~ %w(github github_pr json checkstyle text) }
    end
  end
end
