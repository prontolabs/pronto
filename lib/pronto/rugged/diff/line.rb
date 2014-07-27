module Rugged
  class Diff
    class Line
      def patch
        hunk.delta
      end

      def position
        hunk_index = patch.hunks.find_index { |h| h.header == hunk.header }
        line_index = patch.lines.find_index(self)

        line_index + hunk_index + 1
      end

      def commit
        @commit ||= begin
          repo.lookup(commit_sha) if commit_sha
        end
      end

      def commit_sha
        blame[:final_commit_id] if blame
      end

      def commit_line
        @commit_line ||= begin
          diff = commit.show
          patches = diff ? diff.patches : []
          commit_patch = patches.find do |p|
            patch.new_file_full_path == p.new_file_full_path
          end

          lines = commit_patch ? commit_patch.lines : []
          result = lines.find { |l| blame[:orig_start_line_number] == l.new_lineno }

          result || self # no commit_line means that it was just added
        end
      end

      def ==(other)
        content == other.content &&
          line_origin == other.line_origin &&
          old_lineno == other.old_lineno &&
          new_lineno == other.new_lineno
      end

      private

      def repo
        patch.diff.tree.repo
      end

      def blame
        @blame ||= Blame.new(repo, patch.delta.new_file[:path],
                             min_line: new_lineno, max_line: new_lineno,
                             track_copies_same_file: true,
                             track_copies_any_commit_copies: true)[0]
      end
    end
  end
end
