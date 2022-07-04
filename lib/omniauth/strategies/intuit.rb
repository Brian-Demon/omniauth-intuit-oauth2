require 'omniauth/strategies/oauth2'
require 'crack'

module OmniAuth
  module Strategies
    class Intuit < OmniAuth::Strategies::OAuth2
      DEV_INTUIT_BASE_URL = "https://sandbox-accounts.platform.intuit.com"
      PROD_INPUT_BASE_URL = "https://accounts.platform.intuit.com"
      USER_INFO_ENDPOINT = "/v1/openid_connect/userinfo"
      BASE_SCOPES = "openid email profile"
      VALID_SCOPES = %w[openid profile email phone addess com.intuit.quickbooks.accounting com.intuit.quickbooks.payment].freeze

      option :name, "intuit"

      option :client_options, {
        :site => "https://oauth.platform.intuit.com/op/v1",
        :token_url => "https://oauth.platform.intuit.com/oauth2/v1/tokens/bearer",
        :authorize_url => "https://appcenter.intuit.com/connect/oauth2",
      }

      uid { raw_info['sub'] }

      # option :scope, BASE_SCOPES

      info do
        prune!(
          # email: verified_email,
          # unverified_email: raw_info['email'],
          # email_verified: raw_info['email_verified'],
          email: raw_info['email'],
          first_name: raw_info['given_name'],
          last_name: raw_info['family_name'],
          scopes: options.scope,
          mode: options.mode,
          valid_mode: valid_mode,
          actual_mode: @mode
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
        # if valid_mode && options.mode == :production
        #   @raw_info ||= access_token.get(PROD_INPUT_BASE_URL + USER_INFO_ENDPOINT).parsed
        #   @mode = :production
        # else
          @raw_info ||= access_token.get(DEV_INTUIT_BASE_URL + USER_INFO_ENDPOINT).parsed
        #   @mode = :development
        # end
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

      private

      def callback_url
        full_host + script_name + callback_path
      end
    end
  end
end

OmniAuth.config.add_camelization 'intuit', 'Intuit'
