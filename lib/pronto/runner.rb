require 'tempfile'

module Pronto
  class Runner
    include Plugin

    def self.runners
      repository
    end

    def create_tempfile(blob)
      return if blob.nil?

      file = Tempfile.new(blob.oid)
      file.write(blob.text)
      file.close
      file
    end
  end
end
