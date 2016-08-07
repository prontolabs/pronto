module Pronto
  describe ConfigFile do
    let(:config_file) { described_class.new }

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
              'web_endpoint' => 'https://github.com/'
            }
          )
        end
        it do
          should include(
            'gitlab' => {
              'slug' => nil,
              'api_private_token' => nil,
              'api_endpoint' => nil
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
    end
  end
end
