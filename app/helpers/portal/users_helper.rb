module Portal
  module UsersHelper
    def sanitized_phone(user)
      "***-***-" + user&.person&.phone&.last(4)
    end

    def sanitized_email(user)
      first, last = user.email.split("@")
      "#{first[0]}#{first[1..].gsub(/./, "*")}@#{last}"
    end

    def delivery_message(user, method)
      base = "Enter the 6-digit one-time password we sent to "

      tag = if method == ::User::OTP_DELIVERY_METHOD[:text]
        sanitized_phone(user)
      elsif method == ::User::OTP_DELIVERY_METHOD[:email]
        sanitized_email(user)
      end

      return unless tag

      base + tag
    end
  end
end
