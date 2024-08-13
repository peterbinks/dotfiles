module Portal
  module ImpersonationHelper
    def impersonating?(current_user, true_user)
      current_user.present? && current_user != true_user
    end

    def impersonating_name(current_user)
      current_user&.person&.name
    end
  end
end
