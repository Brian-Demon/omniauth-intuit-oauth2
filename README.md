# omniauth-intuit-oauth2
This gem contains the Intuit strategy for OmniAuth 2.0

## Installation

Usage is as per any other OmniAuth 2.0 strategy. So let's say you're using Rails, you need to add the strategy to your `Gemfile` along side omniauth:

Add this gem to your application's Gemfile:

    gem 'omniauth'
    gem 'omniauth-intuit-oauth2'
    
Then `bundle install`

## Getting Started

You will get your consumer key and secret when you register your app with Intuit Anywhere.
To begin the setup process with Intuit Develeoper visit: https://developer.intuit.com/app/developer/qbo/docs/develop/authentication-and-authorization/oauth-2.0

## How To Use It

Next, you need to add the following to your `config/initializers/omniauth.rb`:

    Rails.application.config.middleware.use OmniAuth::Builder do
      provider :intuit, "consumer_key", "consumer_secret", mode: :sandbox, scope: "openid"
    end

## Mode:

Mode is either `:production` or `:sandbox` as per the Intuit Developer docs: https://developer.intuit.com/app/developer/qbo/docs/develop/sdks-and-samples-collections/nodejs/oauth-nodejs-client#require-the-client

## Scope

Information on scopes can be found: https://developer.intuit.com/app/developer/qbo/docs/learn/scopes

## OmniAuth2

You can now follow the OmniAuth README at: https://github.com/omniauth/omniauth-oauth2

## Contributing
1. Fork it
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create new Pull Request
