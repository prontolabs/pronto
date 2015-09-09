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

      def find_line(path, line_number)
        patch = find_patch_by_path(path)
        lines = patch ? patch.lines : []
        lines.find { |l| l.new_lineno == line_number }
      end

      def find_added_line_with_content(path, content)
        patch = find_patch_by_path(path)
        lines = patch ? patch.added_lines : []
        lines.find { |l| l.content == content }
      end

      private

      def find_patch_by_path(path)
        find { |p| p.new_file_full_path == path }
      end
    end
  end
end
