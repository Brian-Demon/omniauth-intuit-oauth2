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

      def get_token_options(redirect_uri = '')
        { redirect_uri: redirect_uri }.merge(token_params.to_hash(symbolize_keys: true))
      end

      def prune!(hash)
        hash.delete_if do |_, value|
          prune!(value) if value.is_a?(Hash)
          value.nil? || (value.respond_to?(:empty?) && value.empty?)
        end
      end

      def custom_build_access_token
        access_token = get_access_token(request)

        verify_hd(access_token)
        access_token
      end

      alias build_access_token custom_build_access_token

      def get_access_token(request)
        verifier = request.params['code']
        redirect_uri = request.params['redirect_uri']
        access_token = request.params['access_token']
        if verifier && request.xhr?
          client_get_token(verifier, redirect_uri || 'postmessage')
        elsif verifier
          client_get_token(verifier, redirect_uri || callback_url)
        elsif access_token && verify_token(access_token)
          ::OAuth2::AccessToken.from_hash(client, request.params.dup)
        elsif request.content_type =~ /json/i
          begin
            body = JSON.parse(request.body.read)
            request.body.rewind # rewind request body for downstream middlewares
            verifier = body && body['code']
            access_token = body && body['access_token']
            redirect_uri ||= body && body['redirect_uri']
            if verifier
              client_get_token(verifier, redirect_uri || 'postmessage')
            elsif verify_token(access_token)
              ::OAuth2::AccessToken.from_hash(client, body.dup)
            end
          rescue JSON::ParserError => e
            warn "[omniauth google-oauth2] JSON parse error=#{e}"
          end
        end
      end

      def client_get_token(verifier, redirect_uri)
        client.auth_code.get_token(verifier, get_token_options(redirect_uri), get_token_params)
      end

      def get_token_params
        deep_symbolize(options.auth_token_params || {})
      end

      def verify_hd(access_token)
        return true unless options.hd

        @raw_info ||= access_token.get(USER_INFO_URL).parsed

        options.hd = options.hd.call if options.hd.is_a? Proc
        allowed_hosted_domains = Array(options.hd)

        raise CallbackError.new(:invalid_hd, 'Invalid Hosted Domain') unless allowed_hosted_domains.include?(@raw_info['hd']) || options.hd == '*'

        true
      end
    end
  end
end

OmniAuth.config.add_camelization 'intuit', 'Intuit'
