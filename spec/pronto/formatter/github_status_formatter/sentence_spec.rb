module Pronto
  module Formatter
    RSpec.describe GithubStatusFormatter::Sentence do
      let(:sentence) { described_class.new(words) }

      describe '#to_s' do
        subject { sentence.to_s }

        context 'when no words' do
          let(:words) { [] }

          it 'returns empty string' do
            subject.should == ''
          end
        end

        context 'when 1 word' do
          let(:words) { %w[eeny] }

          it 'returns the word' do
            subject.should == 'eeny'
          end
        end

        context 'when 2 words' do
          let(:words) { %w[eeny meeny] }

          it 'uses and to join words' do
            subject.should == 'eeny and meeny'
          end
        end

        context 'when 3 words' do
          let(:words) { %w[eeny meeny miny moe] }

          it 'enumerates words using oxford comma' do
            subject.should == 'eeny, meeny, miny, and moe'
          end
        end
      end
    end
  end
end
