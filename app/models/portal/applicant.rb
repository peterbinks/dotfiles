# Applicant is a combination of PolicyContact::Applicant and Person in dot-com
module Portal
  class Applicant < Base
    attribute :primary
    attribute :co_applicant
    attribute :name
    attribute :user_id
    attribute :person_id

    def primary_insured
      primary == true
    end

    def co_applicant
      primary == false
    end
  end
end
