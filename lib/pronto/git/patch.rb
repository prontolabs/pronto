require 'pathname'

module Pronto
  module Git
    class Patch < Struct.new(:patch, :repo)
      def delta
        patch.delta
      end

      def hunks
        patch.hunks
      end

      def additions
        patch.stat[0]
      end

      def deletions
        patch.stat[1]
      end

      def lines
        @lines ||= begin
          patch.map do |hunk|
            hunk.lines.map { |line| Line.new(line, self, hunk) }
          end.flatten.compact
        end
      end

      def added_lines
        lines.select(&:addition?)
      end

      def deleted_lines
        lines.select(&:deletion?)
      end

      def new_file_full_path
        repo_path = Pathname.new(repo.path).parent
        repo_path.join(patch.delta.new_file[:path])
      end
    end
  end
end
