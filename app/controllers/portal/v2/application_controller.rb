module Portal
  module V2
    class ApplicationController < ::ApplicationController
      include Portal::V2::MetaData
    end
  end
end
