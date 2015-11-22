module Pronto
  class GemNames
    def to_a
      gems = Gem::Specification.find_all.select do |gem|
        if gem.name =~ /^pronto-/
          true
        elsif gem.name != 'pronto'
          runner_path = File.join(gem.full_gem_path, "lib/pronto/#{gem.name}.rb")
          File.exist?(runner_path)
        end
      end

      gems.map { |gem| gem.name.sub(/^pronto-/, '') }.uniq.sort
    end
  end
end
