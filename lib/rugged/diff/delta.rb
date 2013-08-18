module Rugged
  class Diff
    class Delta
      def new_blob
        blob(new_file)
      end

      def old_blob
        blob(old_file)
      end

      def repo
        diff.tree.repo
      end

      private

      def blob(file)
        return if file.nil?
        return if file[:oid] == '0000000000000000000000000000000000000000'

        repo.lookup(file[:oid])
      end
    end
  end
end
