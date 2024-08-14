module Portal
  module IconHelper
    def icon(asset, options = {})
      file = File.read(Rails.root.join("app", "assets", "images", "icon", "#{asset}.svg"))
      doc = Nokogiri::HTML::DocumentFragment.parse file
      svg = doc.at_css "svg"
      if options[:class].present?
        svg["class"] = [svg["class"], options[:class]].join(" ")
      end
      sanitize(doc.to_html, tags: ::Sanitizers::SVG::ALLOWED_ELEMENTS, attributes: ::Sanitizers::SVG::ALLOWED_ATTRIBUTES)
    end

    def icon_class(policy_status_class)
      case policy_status_class
      when "application_signed", "bound", "in_force"
        "icon__primary"
      when "upcoming_cancellation", "cancelled", "declined", "non_renewed", "expired"
        "icon__warning"
      when "tps"
        "icon__tertiary"
      else
        "icon__black"
      end
    end

    def policy_icon(policy, with_label: false, css_classes: "")
      policy_status = policy.try(:status)
      css_class = css_classes.present? ? "#{css_classes} #{icon_class(policy_status)}" : "n-icon icon__xxlarge #{icon_class(policy_status)}"
      if policy.try(:product)
        icon icon_for_product(policy.product, with_label), class: css_class
      elsif policy.try(:policy_type) == "flood"
        icon "funnel_flood", class: css_class
      else
        icon "home", class: css_class
      end
    end

    private

    def icon_for_product(product, with_label)
      if product.product_type == "automotive"
        "auto"
      elsif product.product_type == "home" && product.line == "flood"
        "flood"
      else
        icon_for_product_line(product, with_label)
      end
    end

    def icon_for_product_line(product, with_label)
      icon_product_map = {
        ho3: "house",
        ho6: "condominium",
        hd3: "hybrid-dwelling",
        dp3: "landlord",
        mh3: "manufactured-home"
      }

      label = with_label ? "-with-label" : ""
      icon = icon_product_map[product.line.to_sym]
      icon ? icon + label : "home"
    end
  end
end
