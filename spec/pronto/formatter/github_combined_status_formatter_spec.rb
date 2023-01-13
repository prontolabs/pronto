module Pronto
  module Formatter
    RSpec.describe GithubCombinedStatusFormatter do
      let(:formatter) { described_class.new }

      describe '#format' do
        subject { formatter.format(messages, repo, nil) }

        let(:repo) { Git::Repository.new('spec/fixtures/test.git') }
        let(:runner_class) do
          Class.new do
            def self.title
              'fake_runner'
            end
          end
        end
        let(:message) do
          Pronto::Message.new('app/path', nil, level, '', sha, runner_class)
        end
        let(:sha) { '64dadfdb7c7437476782e8eb024085862e6287d6' }
        let(:status) { Status.new(sha, state, context, description) }
        let(:context) { 'pronto' }

        let(:messages) { [message, message] }

        before do
          Pronto::Github.any_instance
            .should_receive(:create_commit_status)
            .with(status)
            .once
            .and_return(nil)
        end

        context 'when has no messages' do
          let(:messages) { [] }

          let(:state) { :success }
          let(:description) { 'Coast is clear!' }

          it 'has no issues' do
            subject
          end
        end

        context 'when has one message' do
          let(:messages) { [message, message] }

          context 'when severity level is info' do
            let(:level) { :info }

            let(:state) { :success }
            let(:description) { 'Found 1 info.' }

            it 'has issue' do
              subject
            end
          end

          context 'when severity level is warning' do
            let(:level) { :warning }

            let(:state) { :failure }
            let(:description) { 'Found 1 warning.' }

            it 'has warning' do
              subject
            end
          end
        end

        context 'when has multiple messages' do
          let(:level) { :warning }
          let(:level2) { :error }
          let(:message2) do
            Pronto::Message.new('app/path', nil, level2, '', sha, runner_class)
          end

          let(:state) { :failure }
          let(:description) { 'Found 1 warning and 1 error.' }

          context 'order of messages does not matter' do
            context 'ordered' do
              let(:messages) { [message, message2] }

              it 'has issues' do
                subject
              end
            end

            context 'reversed' do
              let(:messages) { [message2, message] }

              it 'has issues' do
                subject
              end
            end
          end
        end
      end
    end
  end
end
