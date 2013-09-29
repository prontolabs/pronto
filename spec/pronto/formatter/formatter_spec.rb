require 'spec_helper'
require 'ostruct'

module Pronto
  module Formatter
    describe '.get' do
      subject { Formatter.get(name) }

      context 'github' do
        let(:name) { 'github' }
        it { should be_an_instance_of GithubFormatter }
      end

      context 'json' do
        let(:name) { 'json' }
        it { should be_an_instance_of JsonFormatter }
      end

      context 'text' do
        let(:name) { 'text' }
        it { should be_an_instance_of TextFormatter }
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
      it { should =~ %w(github json text) }
    end
  end
end
