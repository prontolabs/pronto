module Pronto
  module Git
    class Patches
      include Enumerable

      attr_reader :commit, :repo

      def initialize(repo, commit, patches)
        @commit = commit
        @patches = patches.map { |patch| Git::Patch.new(patch, repo) }
      end

      def each(&block)
        @patches.each(&block)
      end
    end
  end
end
