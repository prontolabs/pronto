require 'tempfile'

module Pronto
  class Runner
    include Plugin

    def self.runners
      repository
    end

    def create_tempfiles(blobs)
      return [] if blobs.nil?

      files = blobs.map { |blob| write(blob) }.compact
      return [] if files.empty?

      begin
        if block_given?
          files.each(&:flush)
          yield(files)
        else
          files
        end
      ensure
        files.each do |file|
          file.close unless file.closed?
        end
      end
    end

    def create_tempfile(blob)
      file = write(blob)
      return if file.nil?

      begin
        if block_given?
          file.flush
          yield(file)
        else
          file
        end
      ensure
        file.close if file && !file.closed?
      end
    end

    private

    def write(blob)
      return if blob.nil?

      file = Tempfile.new(blob.oid)
      file.write(blob.text)
      file
    end
  end
end
