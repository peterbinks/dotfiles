module Portal
  class Applicant < Base
    attribute :primary
    attribute :co_applicant
    attribute :name
    attribute :user_id

    def primary_insured
      primary == true
    end

    def co_applicant
      primary == false
    end
  end
end
