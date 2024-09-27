module Portal
  module Dev
    module QueryMethods
      # This is terribly, terribly expensive, but is helpful for debugging

      # How do I get this to only load in development?
      # development.rb `query_methods: true``
      # production.rb `query_methods: false`
      def source(name, serializer)
        @source = name
        @serializer = serializer
      end

      def first
        source_record = @source.constantize.first
        build(source_record)
      end

      def last
        source_record = @source.constantize.last
        build(source_record)
      end

      def find(id)
        source_record = @source.constantize.find(id)
        build(source_record)
      end

      def find_by(**attrs)
        source_record = @source.constantize.find_by(**attrs)
        build(source_record)
      rescue => e
        nil
      end

      def where(**attrs)
        source_record_collection = @source.constantize.where(**attrs)
        build_collection(source_record_collection)
      rescue => e
        nil
      end

      def build(source_record)
        serialzed_data = @serializer.constantize.new(source_record).to_h.with_associations.data

        new(serialzed_data)
      end

      def build_collection(source_record_collection)
        collection = source_record_collection.map do |source_record|
          build(source_record)
        end

        Portal::Utils::Collection.new(collection)
      end
    end
  end
end
