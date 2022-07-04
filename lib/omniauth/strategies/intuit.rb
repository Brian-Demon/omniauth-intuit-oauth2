require 'omniauth/strategies/oauth2'
require 'crack'

module OmniAuth
  module Strategies
    class Intuit < OmniAuth::Strategies::OAuth2
      USER_INFO_ENDPOINT = "/v1/openid_connect/userinfo"
      BASE_SCOPES = "openid email profile"

      option :name, "intuit"

      option :client_options, {
        :site => "https://oauth.platform.intuit.com/op/v1",
        :token_url => "https://oauth.platform.intuit.com/oauth2/v1/tokens/bearer",
        :authorize_url => "https://appcenter.intuit.com/connect/oauth2",
      }

      option :scope, BASE_SCOPES

      def callback_url
        full_host + script_name + callback_path
      end

      uid { raw_info['sub'] }

      info do
        prune!(
          email: verified_email,
          unverified_email: raw_info['email'],
          email_verified: raw_info['email_verified'],
          first_name: raw_info['given_name'],
          last_name: raw_info['family_name'],
        )
      end

      def raw_info
        @raw_info ||= access_token.get(USER_INFO_ENDPOINT).parsed
      end

      def verified_email
        raw_info['email_verified'] ? raw_info['email'] : nil
      end

      def prune!(hash)
        hash.delete_if do |_, value|
          prune!(value) if value.is_a?(Hash)
          value.nil? || (value.respond_to?(:empty?) && value.empty?)
        end
      end

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

OmniAuth.config.add_camelization 'intuit', 'Intuit'
