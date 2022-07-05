require 'omniauth/strategies/oauth2'
require 'crack'

module OmniAuth
  module Strategies
    class Intuit < OmniAuth::Strategies::OAuth2
      USER_INFO_ENDPOINT = "/v1/openid_connect/userinfo"
      BASE_SCOPES = "openid email profile"
      VALID_SCOPES = %w[openid profile email phone addess com.intuit.quickbooks.accounting com.intuit.quickbooks.payment].freeze
      USER_BASE_URLS = { 
        production: "https://accounts.platform.intuit.com",
        sandbox: "https://sandbox-accounts.platform.intuit.com",
      }

      option :name, "intuit"

      option :client_options, {
        :site => "https://oauth.platform.intuit.com/op/v1",
        :token_url => "https://oauth.platform.intuit.com/oauth2/v1/tokens/bearer",
        :authorize_url => "https://appcenter.intuit.com/connect/oauth2",
      }

      uid { raw_info["sub"] }

      info do
        prune!(
          email: verified_email,
          unverified_email: raw_info["email"],
          email_verified: raw_info["emailVerified"],
          email: raw_info["email"],
          first_name: raw_info["givenName"],
          last_name: raw_info["familyName"],
          # raw_info: @raw_info, # for debugging
        )
      end

      def valid_mode
        valid = false
        if options.mode
          if options.mode.to_sym == :development || options.mode.to_sym == :production
            valid = true
          end
        end
        valid
      end

      def raw_info
        @raw_info ||= access_token.get(user_endpoint_url(mode)).parsed
      end

      def user_endpoint_url(mode)
        user_info_endpoint = nil
        if valid_mode && options.mode == :production
          user_info_endpoint = USER_BASE_URLS[:production] + USER_INFO_ENDPOINT
        else
          user_info_endpoint = USER_BASE_URLS[:sandbox] + USER_INFO_ENDPOINT
        end
        user_info_endpoint
      end

      def verified_email
        raw_info["emailVerified"] ? raw_info["email"] : nil
      end

      def prune!(hash)
        hash.delete_if do |_, value|
          prune!(value) if value.is_a?(Hash)
          value.nil? || (value.respond_to?(:empty?) && value.empty?)
        end
      end

      private

      def callback_url
        full_host + script_name + callback_path
      end
    end
  end
end

OmniAuth.config.add_camelization 'intuit', 'Intuit'
