module Irekia
  module Strategies
    class Mobile < Devise::Strategies::DatabaseAuthenticatable

      def authenticate!
        authentication_hash[:role_id] = Role.politician.first.id if request.params[:datalogger].present?
        super
      end

    end
  end
end
