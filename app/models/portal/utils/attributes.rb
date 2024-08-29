# This module is used to define attributes for classes that include it.
# In your model, do the following to set the attribute to the instance
#
# class Policy
#   attribute :id
#   attribute :policy_number
#   attribute :status
#   attribute :current_term
#
# You will the be able to access the attribute without manually setting attrs like so:
#   policy = Policy.new({id: 1, policy_number: "1234", status: "active", current_term: "1"})
#   policy.id # => 1
#   policy.policy_number # => "1234"
#   policy.status # => "active"
#   policy.current_term # => "1"

module Portal
  module Utils
    module Attributes
      def ATTRIBUTES
        @attributes ||= []
      end

      def attribute(attribute_name)
        self.ATTRIBUTES << attribute_name
      end

      def configure_attributes(klass_instance, data)
        self.ATTRIBUTES.each do |attribute|
          # Set on initialization
          klass_instance.instance_variable_set("@#{attribute}", data[attribute])

          # Getter
          klass_instance.define_singleton_method(attribute) do
            klass_instance.instance_variable_get("@#{attribute}")
          end

          # Setter
          klass_instance.define_singleton_method("#{attribute}=") do |value|
            klass_instance.instance_variable_set("@#{attribute}", value)
          end
        end
      end
    end
  end
end
