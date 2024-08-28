module Portal
  class Coverage < Base
    has_one :policy

    attribute :id
    attribute :flood_and_water_backup

    def initialize(coverage)
      return if coverage.nil?

      super(coverage)
    end

    def flood_and_water_backup?
      @flood_and_water_backup
    end
  end
end
