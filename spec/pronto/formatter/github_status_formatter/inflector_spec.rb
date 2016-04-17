module Pronto
  module Formatter
    RSpec.describe GithubStatusFormatter::Inflector do
      describe '#underscore' do
        subject { described_class.underscore(class_name) }

        context 'when class is just one word' do
          let(:class_name) { 'Pronto::Runner' }

          it { should == 'pronto/runner' }
        end

        context 'when class contains camel case' do
          let(:class_name) { 'Pronto::FakeRunner' }

          it { should == 'pronto/fake_runner' }
        end

        context 'when class contains acronym' do
          let(:class_name) { 'Pronto::SUPERFakeRunner' }

          it { should == 'pronto/super_fake_runner' }
        end
      end
    end
  end
end
