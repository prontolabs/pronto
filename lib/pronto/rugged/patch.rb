module Rugged
  class Patch
    def additions
      stat[0]
    end

    def deletions
      stat[1]
    end

    def added_lines
      lines.select(&:addition?)
    end

    def deleted_lines
      lines.select(&:deletion?)
    end

    def new_file_full_path
      delta.new_file_full_path
    end

    def lines
      map(&:lines).flatten.compact
    end
  end
end
