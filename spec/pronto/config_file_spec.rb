module Pronto
  describe ConfigFile do
    let(:config_file) { described_class.new }

    describe '#path' do
      subject { config_file.path }

      it { should eq '.pronto.yml' }

      context 'when specified by the environment variable' do
        let(:file_path) { '/etc/pronto-config.yml' }

        before do
          stub_const('ENV', 'PRONTO_CONFIG_FILE' => file_path)
        end

        it { should eq file_path }
      end
    end

    describe '#to_h' do
      subject { config_file.to_h }

      context 'not existing config file' do
        it { should include('all' => { 'exclude' => [], 'include' => [] }) }
        it do
          should include(
            'github' => {
              'slug' => nil,
              'access_token' => nil,
              'api_endpoint' => 'https://api.github.com/',
              'web_endpoint' => 'https://github.com/',
              'review_type' => 'request_changes'
            }
          )
        end
        it do
          should include(
            'gitlab' => {
              'slug' => nil,
              'api_private_token' => nil,
              'api_endpoint' => 'https://gitlab.com/api/v4'
            }
          )
        end
        it { should include('runners' => []) }
        it { should include('formatters' => []) }
      end

      context 'only global excludes in file' do
        before do
          File.should_receive(:exist?)
            .and_return(true)

          YAML.should_receive(:load_file)
            .and_return('all' => { 'exclude' => ['a/**/*.rb'] })
        end

        it do
          should include(
            'all' => {
              'exclude' => ['a/**/*.rb'], 'include' => []
            }
          )
        end
      end

      context 'a value is set to false' do
        before do
          File.should_receive(:exist?)
            .and_return(true)

          YAML.should_receive(:load_file)
            .and_return('verbose' => false)
        end

        it { should include('verbose' => false) }
      end
    end
  end
end
