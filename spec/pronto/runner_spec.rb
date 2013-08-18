require 'spec_helper'
require 'ostruct'

module Pronto
  describe Runner do
    let(:runner) { Runner.new }

    let(:file) do
      file = mock(:file)
      file.stub(:write)
      file.stub(:closed?).and_return(closed)
      Tempfile.stub(:new).and_return(file)
      file
    end

    describe '#create_tempfile' do
      subject { runner.create_tempfile(blob) }

      context 'blob is nil' do
        let(:blob) { nil }
        it { should be_nil }
      end

      context 'blob with a single line of text' do
        let(:blob) { OpenStruct.new(oid: '123', text: '321') }

        context 'file gets closed' do
          before { file.stub(:close).never }
          let(:closed) { true }
          it { should == file }
        end

        context 'file does not get closed' do
          before { file.stub(:close).once }
          let(:closed) { false }
          it { should == file }
        end
      end
    end

    describe '#create_tempfiles' do
      subject { runner.create_tempfiles(blobs) }

      context 'blobs is nil' do
        let(:blobs) { nil }
        it { should == [] }
      end

      context 'blobs is not nil' do
        let(:blobs) { [blob, blob] }

        context 'blobs are nil' do
          let(:blob) { nil }
          it { should == [] }
        end

        context 'blobs have a single line of text' do
          before { file.stub(:close).never }
          let(:blob) { OpenStruct.new(oid: '123', text: '321') }
          let(:closed) { true }
          it { should == [file,file] }
        end
      end
    end
  end
end
