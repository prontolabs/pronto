module Pronto
  describe Config do
    let(:config) { described_class.new(config_hash) }
    let(:config_hash) { {} }

    describe '#github_slug' do
      subject { config.github_slug }

      context 'from env variable' do
        before { stub_const('ENV', 'PRONTO_GITHUB_SLUG' => 'prontolabs/pronto') }
        it { should == 'prontolabs/pronto' }
      end

      context 'from config hash' do
        let(:config_hash) { { 'github' => { 'slug' => 'rails/rails' } } }
        it { should == 'rails/rails' }
      end
    end

    describe '#github_web_endpoint' do
      subject { config.github_web_endpoint }

      context 'from env variable' do
        before { stub_const('ENV', 'PRONTO_GITHUB_WEB_ENDPOINT' => '4.2.2.2') }
        it { should == '4.2.2.2' }
      end

      context 'from config hash' do
        let(:config_hash) { { 'github' => { 'web_endpoint' => 'localhost' } } }
        it { should == 'localhost' }
      end

      context 'default' do
        let(:config_hash) { ConfigFile::EMPTY }
        it { should == 'https://github.com/' }
      end
    end

    describe '#github_hostname' do
      subject { config.github_hostname }
      let(:config_hash) { ConfigFile::EMPTY }
      it { should == 'github.com' }
    end

    describe '#gitlab_slug' do
      subject { config.gitlab_slug }

      context 'from env variable' do
        before { stub_const('ENV', 'PRONTO_GITLAB_SLUG' => 'rick/deckard') }
        it { should == 'rick/deckard' }
      end

      context 'from config hash' do
        let(:config_hash) { { 'gitlab' => { 'slug' => 'ruby/ruby' } } }
        it { should == 'ruby/ruby' }
      end
    end

    describe '#max_warnings' do
      subject { config.max_warnings }

      context 'from env variable' do
        context 'with a valid value' do
          before { stub_const('ENV', 'PRONTO_MAX_WARNINGS' => '20') }
          it { should == 20 }
        end

        context 'with an invalid value' do
          before { stub_const('ENV', 'PRONTO_MAX_WARNINGS' => 'twenty') }

          specify do
            -> { subject }.should raise_error(ArgumentError)
          end
        end
      end

      context 'from config hash' do
        let(:config_hash) { { 'max_warnings' => 40 } }
        it { should == 40 }
      end

      context 'default' do
        let(:config_hash) { ConfigFile::EMPTY }
        it { should == nil }
      end
    end

    describe '#message_format' do
      subject { config.message_format('whatever') }

      context 'when there is an entry in the config file' do
        let(:config_hash) { { 'whatever' => { 'format' => whatever_format } } }
        let(:whatever_format) { "that's just like your opinion man" }

        it { should == whatever_format }
      end

      context 'when there is no entry in the config file' do
        let(:config_hash) { ConfigFile::EMPTY }

        it { should == ConfigFile::DEFAULT_MESSAGE_FORMAT }
      end
    end
  end
end
