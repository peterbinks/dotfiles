module Portal
  module Utils
    class Collection
      attr_reader :records

      def initialize(records)
        @records = records
      end

      def first
        records.first
      end

      def last
        records.last
      end

      def find(id)
        records.find { |record| record.id == id }
      end

      def find_by(**attrs)
        where(**attrs).first
      end

      def where(**attrs)
        records.select do |record|
          attrs.all? do |key, value|
            record.send(key) == value
          end
        end
      end
    end
  end
end
