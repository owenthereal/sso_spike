require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class ACL < OmniAuth::Strategies::OAuth2
      option :client_options, {
        :site => 'http://accounts.aclcloud.dev/api',
        :authorize_url => 'http://accounts.aclcloud.dev/users/sign_in',
        :token_url => 'http://accounts.aclcloud.dev/login/oauth/access_token'
      }

      def request_phase
        super
      end

      def authorize_params
        if request.params["scope"]
          super.merge({:scope => request.params["scope"]})
        else
          super
        end
      end

      uid { raw_info['id'].to_s }

      info do
        {
          'email' => email
        }
      end

      extra do
        {:raw_info => raw_info}
      end

      def raw_info
        access_token.options[:mode] = :query
        access_token.options[:param_name] = "oauth_token"
        @raw_info ||= access_token.get('/api/user.json').parsed
      end

      def email
        raw_info['email']
      end
    end
  end
end

OmniAuth.config.add_camelization 'acl', 'ACL'
