module Api
  class ApplicationController < ActionController::Base
    before_filter :authenticate_client!
    before_filter :print_session

    def print_session
      logger.debug session.inspect
    end

    def authenticate_client!
      @current_token = Songkick::OAuth2::Provider.access_token(nil, [], request)
      logger.debug @current_token.inspect

      throw(:warden) unless @current_token.valid?
    end

    def current_token
      @current_token
    end

    def current_user
      current_token.owner
    end
  end
end
