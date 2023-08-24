require "base64"
require "oauth2"
require "omniauth-oauth2"

module OmniAuth
  module Strategies
    # OmniAuth strategy for zoom.us
    class Zoom < OmniAuth::Strategies::OAuth2
      option :name, "zoom"
      option :client_options, site: "https://zoom.us"

      uid { raw_info["id"] }
      extra { {raw_info: raw_info} }

      def token_params
        params = super
        params[:headers] ||= {}
        params[:headers][:Authorization] = format("Basic %s", Base64.strict_encode64("#{client.id}:#{client.secret}"))
        params
      end

      private

      def raw_info
        return @raw_info if defined?(@raw_info)

        @raw_info = access_token.get("/v2/users/me").parsed || {}
      rescue ::OAuth2::Error => e
        raise e unless e.response.status == 400

        # in case of missing a scope for reading current user info
        log(:error, "#{e.class} occured. message:#{e.message}")
        @raw_info = {}
      end

      def callback_url
        full_host + callback_path
      end
    end
  end
end
