module Portal
  module ProductsHelper
    def active_third_party_products(product_type = nil)
      scope = Product.includes(:insurance_carrier).where(administrated: false, active: true)
      scope.where!(product_type: product_type) if product_type.present?
      @active_third_party_products ||= scope
        .order(:product_type, :state, :line, "insurance_carriers.name")
    end

    # Whether or not the current user is allowed to edit the given rule
    # @param rule [Lifecycle::Rule::Base]
    # @return [bool]
    def can_edit_rule?(rule)
      if current_user.has_role?(:developer) && has_json_editor?(rule)
        true
      elsif has_json_editor?(rule)
        false
      else
        current_user.has_role?(:lifecycle_editor)
      end
    end

    def has_json_editor?(rule)
      !rule.has_simple_config? && rule.config.present?
    end

    def full_product_name(product)
      [product.state,
        product.line.upcase,
        product.product_type&.titleize,
        product.effective_date&.to_s(:kin_ymd_date)].join(" ")
    end

    def product_type_display(product)
      if product.ho6?
        "Condo"
      elsif product.dp3?
        "Dwelling"
      elsif product.mh3?
        "Mobile Home"
      else
        product.product_type.titleize
      end
    end

    def file_upload_requirements(rule)
      case rule.class.name.demodulize
      when "RestrictedZipCode", "StatementOfNoLossMoratoria", "MoratoriaPriorInsurance"
        I18n.t("products.restricted_zip_code_file_upload_requirements")
      when "RiskyZipCode"
        I18n.t("products.risky_zip_code_file_upload_requirements")
      end
    end
  end
end
