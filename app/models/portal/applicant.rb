module Portal
  class Applicant < Base
    def self.get_applicants(policy_number:)
      Portal::Api::ApplicantSerializer.get_applicants(policy_number:).map { |applicant| new(applicant.data) }
    end

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
