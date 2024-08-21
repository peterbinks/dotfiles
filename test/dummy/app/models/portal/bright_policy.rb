module Portal
  class BrightPolicy
    attr_accessor :status

    def initialize(status:)
      @status = status
    end
  end
end
