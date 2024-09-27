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
      def HAS_MANY_ASSOCIATIONS
        @has_many_associations ||= []
      end

      def has_many(association_name)
        self.HAS_MANY_ASSOCIATIONS << association_name
      end

      def configure_has_many(klass_instance, data)
        self.HAS_MANY_ASSOCIATIONS.each do |association_name|
          klass_instance.define_singleton_method(association_name) do
            raise "Association #{association_name} not defined" unless data[association_name]
            data[association_name].map { |record| Portal.const_get(association_name.to_s.classify).new(record) }
          end
        end
      end
    end
  end
end
