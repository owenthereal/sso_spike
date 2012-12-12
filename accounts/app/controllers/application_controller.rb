class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  before_filter :print_session

  def print_session
    logger.debug session.inspect
  end

  def sign_in(*args)
    result = super

    if user_signed_in?
      if oauth.valid? && same_domain?(oauth.redirect_uri)
        oauth.grant_access!
        cookies[:code] = {
          value: oauth.code
        }
      else
        oauth.deny_access!
        cookies.delete(:code)
      end
    end

    result
  end

  def sign_out(*args)
    result = super
    cookies.delete(:code)

    result
  end

  def after_sign_in_path_for(resource_or_scope)
    redirect_uri || super(resource_or_scope)
  end

  def after_sign_out_path_for(resource_or_scope)
    redirect_uri || super(resource_or_scope)
  end

  def after_sign_up_path_for(resource_or_scope)
    redirect_uri || super(resource_or_scope)
  end

  def redirect_uri
    @redirect_uri ||= oauth.valid? ? oauth.client.redirect_uri : nil
  end

  def redirect_uri?
    redirect_uri.present?
  end

  helper_method :oauth
  def oauth
    @oauth ||= Songkick::OAuth2::Provider.parse(current_user, request)
  end

  private

  def same_domain?(uri)
    return false unless uri

    uri = URI.parse(uri).to_s
    regex = /^.+\.#{request.domain.gsub('.', '\.')}/
    uri =~ regex
  end
end
