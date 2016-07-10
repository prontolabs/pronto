module Pronto
  Status = Struct.new(:sha, :state, :context, :description) do
    def ==(other)
      sha == other.sha &&
        state == other.state &&
        context == other.context &&
        description == other.description
    end

    def to_s
      "[#{sha}] #{context} #{state} - #{description}"
    end
  end
end
