require 'pathname'

module Rugged
  class Diff
    class Delta
      def repo
        diff.tree.repo
      end

      def new_file_full_path
        repo_path = Pathname.new(repo.path).parent
        repo_path.join(new_file[:path])
      end
    end
  end
end
