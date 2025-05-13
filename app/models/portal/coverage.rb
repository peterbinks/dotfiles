module Portal
  class Coverage < Base
    attribute :id
    attribute :flood_and_water_backup

    def initialize(coverage)
      return if coverage.nil?

      super
    end

    def flood_and_water_backup?
      @flood_and_water_backup
    end
  end
end
