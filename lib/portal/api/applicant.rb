module Portal
  module Api
    class Applicant < Base
      dotcom_api Portal::Api::Actions::Applicants

      def self.get_applicants(policy_number:)
        DotcomAPI::Get
          .request(policy_number:)
          .map { |applicant| Portal::Applicant.new(applicant.data) }
      end
    end
  end
end
