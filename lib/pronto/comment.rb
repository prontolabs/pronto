module Pronto
  Comment = Struct.new(:sha, :body, :path, :position) do
    def ==(other)
      position == other.position &&
        path == other.path &&
        body == other.body
    end

    def to_s
      "[#{sha}] #{path}:#{position} - #{body}"
    end
  end
end
