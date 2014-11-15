require 'pathname'

module Pronto
  module Git
    class Repository
      def initialize(path)
        @repo = Rugged::Repository.new(path)
      end

      def diff(commit, options = nil)
        if commit == :index
          patches = @repo.index.diff(options)
          Patches.new(self, head, patches)
        else
          merge_base = merge_base(commit)
          patches = @repo.diff(merge_base, head, options)
          Patches.new(self, merge_base, patches)
        end
      end

      def show_commit(sha)
        return empty_patches(sha) unless sha

        commit = @repo.lookup(sha)
        return empty_patches(sha) if commit.parents.count != 1

        # TODO: Rugged does not seem to support diffing against multiple parents
        diff = commit.diff(reverse: true)
        return empty_patches(sha) if diff.nil?

        Patches.new(self, sha, diff.patches)
      end

      def commits_until(sha)
        result = []
        @repo.walk(head, Rugged::SORT_TOPO).take_while do |commit|
          result << commit.oid
          !commit.oid.start_with?(sha)
        end
        result
      end

      def path
        Pathname.new(@repo.path).parent
      end

      def blame(patch, lineno)
        Rugged::Blame.new(@repo, patch.delta.new_file[:path],
                          min_line: lineno, max_line: lineno,
                          track_copies_same_file: true,
                          track_copies_any_commit_copies: true)[0]
      end

      def branch
        @repo.head.name.sub('refs/heads/', '') if @repo.head.branch?
      end

      def remote_urls
        @repo.remotes.map(&:url)
      end

      private

      def empty_patches(sha)
        Patches.new(self, sha, [])
      end

      def merge_base(commit)
        @repo.merge_base(commit, head)
      end

      def head
        @repo.head.target
      end
    end
  end
end
