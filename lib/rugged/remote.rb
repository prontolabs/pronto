module Rugged
  class Remote
    def github_slug
      match = /.*github.com(:|\/)(?<slug>.*).git/.match(url)
      match[:slug] if match
    end
  end
end
