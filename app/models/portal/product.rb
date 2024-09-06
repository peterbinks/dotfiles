module Portal
  class Product < Base
    attribute :id
    attribute :line
    attribute :state
    attribute :product_type

    delegate :ho3?, :dp3?, :mh3?, :ho6?, to: :product_line

    def initialize(product)
      return if product.nil?

      super(product)
    end

    def product_line
      ActiveSupport::StringInquirer.new(line)
    end
  end
end
