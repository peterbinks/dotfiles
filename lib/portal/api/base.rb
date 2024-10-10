module Portal
  module Api
    class Base
      def self.dotcom_api(source)
        const_set(:DotcomAPI, source)
      end
    end
  end
end
