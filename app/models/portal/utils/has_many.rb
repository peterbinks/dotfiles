# This is a custom module that is used to define has_many associations between classes.
# This IS NOT the "has_many" association provided by ActiveRecord
# This has_many association is connecting class instances to other class instances.
#
# In your model, do the following to set a has_many association
#
# class Policy
#   has_many :billing_transactions
#   has_many :documents
#
# You will then be able to access the has_many association like so:
#   policy = Policy.new({
#     billing_transactions: [{id: 1, amount: 100.00}, {id: 2, amount: 200.00}],
#     documents: [{id: 1, name: "doc1"}, {id: 2, name: "doc2"}]
#   })
#   policy.billing_transactions # => [<BillingTransaction>, <BillingTransaction>]
#   policy.documents # => [<Document>, <Document>]

module Portal
  module Utils
    module HasMany
      NestedArrayError = Class.new(StandardError)

      def HAS_MANY_ASSOCIATIONS
        @has_many_associations ||= []
      end

      def has_many(association_name)
        self.HAS_MANY_ASSOCIATIONS << association_name
      end

      def configure_has_many(klass_instance, data)
        self.HAS_MANY_ASSOCIATIONS.each do |association_name|
          klass_instance.define_singleton_method(association_name) do
            self.class.handle_errors(data, association_name)

            records = data[association_name].map { |record| self.class.build_portal_record(record, association_name) }

            Portal::Utils::Collection.new(records)
          end
        end
      end

      def build_portal_record(record, association_name)
        # If the record is already a Portal::Base instance, return it
        return record if record.is_a?(Portal::Base)

        # Otherwise, create a new instance of the associated class
        Portal.const_get(association_name.to_s.classify).new(record)
      end

      def handle_errors(data, association_name)
        raise "Association #{association_name} not defined" unless data[association_name]

        raise NestedArrayError.new("`has_many` association for #{association_name} is too deeply nested. Check that you're not putting an array inside of another array, like `[documents]`") if data[association_name].is_a?(Array) && data[association_name].first.is_a?(Array)
      end
    end
  end
end
