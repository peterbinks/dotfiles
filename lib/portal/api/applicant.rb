module Portal
  module Api
    class Applicant
      def self.get_applicants(policy_number:)
        Portal::Api::ApplicantSerializer
          .get_applicants(policy_number:)
          .map { |applicant| Portal::Applicant.new(applicant.data) }
      end
    end
  end
end
