# This is a custom module that is used to define has_one associations between classes.
# This IS NOT the "has_one" association provided by ActiveRecord
# This has_one association is connecting class instances to other class instances.
#
# In your model, do the following to set a has_one association
#
# class Policy
#   has_one :property
#   has_one :coverage
#
# You will then be able to access the has_one association like so:
#   policy = Policy.new({
#     property: {id: 1, address: "123 Main St"},
#     coverage: {id: 1, amount: 100000}
#   })
#   policy.property # => <Property>
#   policy.coverage # => <Coverage>

module Portal
  module Utils
    module HasOne
      def HAS_ONE_ASSOCIATIONS
        @has_one_associations ||= []
      end

      def has_one(association_name)
        self.HAS_ONE_ASSOCIATIONS << association_name
      end

      def configure_has_one(klass_instance, data)
        self.HAS_ONE_ASSOCIATIONS.each do |association_name|
          klass_instance.define_singleton_method(association_name) do
            return nil if data[association_name].nil?

            Portal.const_get(association_name.to_s.classify).new(data[association_name])
          end
        end
      end
    end
  end
end
