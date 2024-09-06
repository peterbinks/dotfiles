module Portal
  module ApplicationHelper
    def validated_form_with(args)
      form_with(**args) do |form|
        concat(content_tag("kin-form-validation", ""))
        yield(form)
      end
    end
  end
end
