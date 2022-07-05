# omniauth-intuit-oauth2
This gem contains the Intuit strategy for OmniAuth 2.0

## How To Use It

Usage is as per any other OmniAuth 2.0 strategy. So let's say you're using Rails, you need to add the strategy to your `Gemfile` along side omniauth:

    gem 'omniauth'
    gem 'omniauth-intuit-oauth2'

Next, you need to add the following to your `config/initializers/omniauth.rb`:

    Rails.application.config.middleware.use OmniAuth::Builder do
      provider :intuit, "consumer_key", "consumer_secret", mode: :sandbox, scope: "openid"
      # mode **
      # scope ***
    end
** mode is either `:production` or `:sandbox` as per the Intuit Developer docs: https://developer.intuit.com/app/developer/qbo/docs/develop/sdks-and-samples-collections/nodejs/oauth-nodejs-client#require-the-client

*** Information on scopes can be found: https://developer.intuit.com/app/developer/qbo/docs/learn/scopes

You will get your consumer key and secret when you register your app with Intuit Anywhere.
To begin the setup process with Intuit Develeoper visit: https://developer.intuit.com/app/developer/qbo/docs/develop/authentication-and-authorization/oauth-2.0

You can now follow the OmniAuth README at: https://github.com/omniauth/omniauth-oauth2
