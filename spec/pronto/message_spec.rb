module Pronto
  describe Message do
    let(:message) { described_class.new(path, line, level, msg, '8cda581') }

    let(:path) { 'README.md' }
    let(:line) { Git::Line.new }
    let(:msg) { 'message' }
    let(:level) { :warning }

    describe '.new' do
      subject { message }

      Message::LEVELS.each do |message_level|
        context "set log level to #{message_level}" do
          let(:level) { message_level }
          its(:level) { should == message_level }
        end
      end

      context 'bad level' do
        let(:level) { :random }
        specify do
          -> { subject }.should raise_error(::ArgumentError)
        end
      end
    end

    describe '#full_path' do
      subject { message.full_path }

      context 'line is nil' do
        let(:line) { nil }
        it { should be_nil }
      end
    end

    describe '#repo' do
      subject { message.repo }

      context 'line is nil' do
        let(:line) { nil }
        it { should be_nil }
      end
    end

    describe '#==' do
      subject { message == other }

      context 'path, msg and line match' do
        let(:other) { described_class.new(path, line, level, msg, '1111') }
        it { should be_truthy }
      end

      context 'without lines, path, msg and sha match' do
        let(:line) { nil }
        let(:other) { described_class.new(path, nil, level, msg, '8cda581') }
        it { should be_truthy }
      end

      context 'only path and msg match' do
        let(:other) { described_class.new(path, nil, level, msg, '1111') }
        it { should be_falsy }
      end
    end
  end
end
