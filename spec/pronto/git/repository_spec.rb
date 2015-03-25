require 'spec_helper'

describe Pronto do
  let(:repo) { Pronto::Git::Repository.new('spec/fixtures/test.git') }

  describe '#path' do
    subject { repo.path }
    its(:to_s) { should end_with 'pronto/spec/fixtures' }
  end
end
