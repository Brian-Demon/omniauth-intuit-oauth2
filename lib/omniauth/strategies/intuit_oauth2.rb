require 'omniauth/strategies/oauth2'
require 'crack'

module OmniAuth
  module Strategies
    class IntuitOauth2 < OmniAuth::Strategies::OAuth2
      option :name, "intuit_oauth2"

      option :client_options, {
        :site => 'https://oauth.platform.intuit.com/op/v1',
        :token_url => 'https://oauth.platform.intuit.com/oauth2/v1/tokens/bearer',
        :authorize_url => 'https://appcenter.intuit.com/connect/oauth2',
      }

      def callback_url
        full_host + script_name + callback_path
      end

      # uid{ raw_info['id'] }

      # info do
      #         {
      #           :first_name => raw_info['firstName'],
      #           :last_name => raw_info['lastName'],
      #           :name => "#{raw_info['firstName']} #{raw_info['lastName']}",
      #           :email => raw_info['email'],
      #           :data_source => raw_info['dataSource'],
      #           :oauth_verifier => raw_info['oauth_verifier'],
      #           :realm_id => raw_info['realmId']
      #
      #         }
      #       end
      #
      #       extra do
      #         { 'raw_info' => raw_info }
      #       end
      #
      #       def raw_info
      #         # access_token.get(path, headers={})
      #         # dataSource
      #         #         "QBO"
      #         #         oauth_token
      #         #         "qyprdhjNbeM7UGDHYrgSvwqCRUQP0nZejdHw3IIFTaHY8mj5"
      #         #         oauth_verifier
      #         #         "ee3njpe"
      #         #         realmId
      #         #         "313247180"
      #
      #         puts "==================="
      #         # access_token.get("/auth/intuit/callback").body
      #         puts "==================="
      #         @raw_info ||= Crack::XML.parse(access_token.get("").body)["RestResponse"]
      #       end
    end
  end
end

OmniAuth.config.add_camelization 'intuit-oauth2', 'IntuitOauth2'
