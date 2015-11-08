module Pronto
  module Git
    class Patches
      include Enumerable

      attr_reader :commit, :repo

      def initialize(repo, commit, patches)
        @repo = repo
        @commit = commit
        @patches = patches.map { |patch| Git::Patch.new(patch, repo) }
      end

      def each(&block)
        @patches.each(&block)
      end

      def reject!(&block)
        @patches.reject!(&block)
      end

      def find_line(path, line)
        patch = find { |p| p.new_file_full_path == path }
        lines = patch ? patch.lines : []
        lines.find { |l| l.new_lineno == line }
      end
    end
  end
end
