# omniauth-intuit-oauth2
This gem contains the Intuit strategy for OmniAuth 2.0

## How To Use It

Usage is as per any other OmniAuth 1.0 strategy. So let's say you're using Rails, you need to add the strategy to your `Gemfile` along side omniauth:

    gem 'omniauth'
    gem 'omniauth-intuit-oauth2'

Next, you need to add the following to your `config/initializers/omniauth.rb`:

    Rails.application.config.middleware.use OmniAuth::Builder do
      provider :intuit, "consumer_key", "consumer_secret" 
    end

You will get your consumer key and secret when you register your app with Intuit Anywhere.  (See
https://ipp.developer.intuit.com/0010_Intuit_Partner_Platform/0030_Intuit_Anywhere/0040_Hello_World_IA for an example)

You can now follow the OmniAuth README at: https://github.com/intridea/omniauth
