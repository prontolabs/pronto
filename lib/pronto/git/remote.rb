module Pronto
  module Git
    class Remote < Struct.new(:remote)
      def github_slug
        match = /.*github.com(:|\/)(?<slug>.*).git/.match(remote.url)
        match[:slug] if match
      end
    end
  end
end
