module Pronto
  module Formatter
    describe JunitFormatter do
      let(:formatter) { described_class.new }

      describe '#format' do
        subject { formatter.format(messages, repo, patches) }
        let(:repo) { double(path: Pathname.new('/repo')) }
        let(:line) { double(new_lineno: 1, commit_sha: '123', patch: double(repo: repo)) }
        let(:runner) { double(title: 'rubocop') }
        let(:error) { Message.new('path/to.rb', line, :error, 'Line Error', nil, runner) }
        let(:warning) { Message.new('path/to.rb', line, :warning, 'Line Warning', nil, runner) }
        let(:messages) { [error, warning] }
        let(:patches) { [double(new_file_path: 'path/to.rb', new_file_full_path: '/repo/path/to.rb', additions: 1)] }
        let(:runners) { [runner] }
        let(:config) { Config.new(ConfigFile::EMPTY) }

        before { Runner.stub(:runners).and_return(runners) }
        before { formatter.stub(:config).and_return(config) }

        it { should eq load_fixture('junit_message_with_path.xml') }

        context 'message without path' do
          let(:messages) { [Message.new(nil, line, :error, 'Line Error', nil, runner)] }
          let(:patches) { [] }

          it { should eq load_fixture('junit_message_without_path.xml') }
        end

        context 'message without line' do
          let(:messages) { [Message.new('path/to.rb', nil, :error, 'Line Error', '123', runner)] }

          it { should eq load_fixture('junit_message_without_line.xml') }
        end

        context 'message without runner' do
          let(:messages) { [Message.new('path/to.rb', line, :error, 'Line Error')] }
          let(:runners) { [] }

          it { should eq load_fixture('junit_message_without_runner.xml') }
        end

        context 'message with repeated spaces in path' do
          let(:messages) { [Message.new('docs/a  b.rb', line, :error, 'Line Error', nil, runner)] }
          let(:patches) { [] }

          it { should eq load_fixture('junit_message_with_spaces_in_path.xml') }
        end

        context 'no messages' do
          let(:messages) { [] }

          it { should eq load_fixture('junit_no_messages.xml') }
        end

        context 'runner without messages' do
          let(:runners) { [runner, double(title: 'brakeman')] }

          it { should eq load_fixture('junit_runner_without_messages.xml') }
        end

        context 'skipped runner' do
          let(:runners) { [runner, double(title: 'brakeman')] }
          let(:config) { Config.new(ConfigFile::EMPTY.merge('skip_runners' => ['brakeman'])) }

          it { should eq load_fixture('junit_message_with_path.xml') }
        end

        context 'runner missing from runners config' do
          let(:runners) { [runner, double(title: 'brakeman')] }
          let(:config) { Config.new(ConfigFile::EMPTY.merge('runners' => ['rubocop'])) }

          it { should eq load_fixture('junit_message_with_path.xml') }
        end

        context 'runner after max warnings reached' do
          let(:runners) { [runner, double(title: 'brakeman')] }
          let(:config) { Config.new(ConfigFile::EMPTY.merge('max_warnings' => 2)) }

          it { should eq load_fixture('junit_message_with_path.xml') }
        end

        context 'runner before max warnings reached' do
          let(:runners) { [runner, double(title: 'brakeman')] }
          let(:config) { Config.new(ConfigFile::EMPTY.merge('max_warnings' => 3)) }

          it { should eq load_fixture('junit_runner_without_messages.xml') }
        end

        context 'file without messages' do
          let(:patches) do
            [double(new_file_path: 'path/to.rb', new_file_full_path: '/repo/path/to.rb', additions: 1),
             double(new_file_path: 'lib/other.rb', new_file_full_path: '/repo/lib/other.rb', additions: 1)]
          end

          it { should eq load_fixture('junit_file_without_messages.xml') }
        end

        context 'file without additions' do
          let(:patches) do
            [double(new_file_path: 'path/to.rb', new_file_full_path: '/repo/path/to.rb', additions: 1),
             double(new_file_path: 'lib/old.rb', new_file_full_path: '/repo/lib/old.rb', additions: 0)]
          end

          it { should eq load_fixture('junit_message_with_path.xml') }
        end

        context 'file excluded for all runners' do
          let(:patches) do
            [double(new_file_path: 'path/to.rb', new_file_full_path: '/repo/path/to.rb', additions: 1),
             double(new_file_path: 'lib/other.rb', new_file_full_path: '/repo/lib/other.rb', additions: 1)]
          end

          before { config.stub(:excluded_files) { |runner| runner == 'all' ? ['/repo/lib/other.rb'] : [] } }

          it { should eq load_fixture('junit_message_with_path.xml') }
        end

        context 'file excluded for one runner' do
          let(:runners) { [runner, double(title: 'brakeman')] }

          before { config.stub(:excluded_files) { |runner| runner == 'brakeman' ? ['/repo/path/to.rb'] : [] } }

          it { should eq load_fixture('junit_message_with_path.xml') }
        end

        context 'when called twice' do
          it 'does not repeat earlier output' do
            formatter.format(messages, repo, patches)

            subject.should eq load_fixture('junit_message_with_path.xml')
          end
        end
      end
    end
  end
end
