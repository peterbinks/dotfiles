module Portal
  class Term < Base
    attribute :effective_date
    attribute :end_date
    attribute :number

    def initialize(term)
      return if term.nil?

      super
    end
  end
end
