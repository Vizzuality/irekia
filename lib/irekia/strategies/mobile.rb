module Irekia
  module Strategies
    class Mobile < Devise::Strategies::DatabaseAuthenticatable

      def authenticate!
        device = AgentOrange::UserAgent.new(request.user_agent).device
        authentication_hash[:role_id] = Role.politician.first.id if device.is_mobile?
        super
      end

    end
  end
end
