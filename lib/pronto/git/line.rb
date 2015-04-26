module Pronto
  module Git
    Line = Struct.new(:line, :patch, :hunk) do
      extend Forwardable

      def_delegators :line, :addition?, :deletion?, :content, :new_lineno,
                     :old_lineno, :line_origin

      def position
        hunk_index = patch.hunks.find_index { |h| h.header == hunk.header }
        line_index = patch.lines.find_index(line)

        line_index + hunk_index + 1
      end

      def commit_sha
        blame[:final_commit_id] if blame
      end

      def commit_line
        @commit_line ||= begin
          patches = patch.repo.show_commit(commit_sha)

          result = patches.find_line(patch.new_file_full_path,
                                     blame[:orig_start_line_number])
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

      def blame
        @blame ||= patch.blame(new_lineno)
      end
    end
  end
end
