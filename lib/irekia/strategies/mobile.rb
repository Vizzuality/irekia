module Irekia
  module Strategies
    class Mobile < Devise::Strategies::DatabaseAuthenticatable

      def authenticate!
        authentication_hash[:role_id] = Role.politician.first.id
        super
      end

      def valid?
        device = AgentOrange::UserAgent.new(request.user_agent).device
        super && device.is_mobile?
      end

    end
  end
end
