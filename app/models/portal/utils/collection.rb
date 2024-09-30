# Portal::Utils::Collection builds an in-memory collection of objects with special methods
# It does NOT fetch from the database
module Portal
  module Utils
    class Collection < Array
      attr_reader :records

      def initialize(records)
        super(records)
      end

      def find(id)
        Array.new(self).find { |record| record.id == id }
      end

      def find_by(**attrs)
        where(**attrs).first
      end

      def where(**attrs)
        Array.new(self).select do |record|
          attrs.all? do |key, value|
            record.send(key) == value
          end
        end
      end
    end
  end
end
