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

      begin
        if block_given?
          file.flush
          yield(file)
        else
          file
        end
      ensure
        file.close unless file.closed?
      end
    end
  end
end
