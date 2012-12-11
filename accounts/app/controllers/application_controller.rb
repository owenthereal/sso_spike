class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  before_filter :print_session

  def print_session
    logger.debug session.inspect
  end

  def after_sign_in_path_for(resource_or_scope)
    oauth2 = Songkick::OAuth2::Provider.parse(current_user, request)
    logger.debug oauth2.inspect

    if oauth2.valid? && same_domain?(oauth2.redirect_uri)
      oauth2.grant_access!
      session[:auth_token] = oauth2.access_token
    else
      oauth2.deny_access!
      session.delete(:auth_token)
    end

    oauth2.client.try(:redirect_uri) || super(resource_or_scope)
  end

  def after_sign_out_path_for(resource_or_scope)
    redirect_uri || super(resource_or_scope)
  end

  def after_sign_up_path_for(resource_or_scope)
    redirect_uri || super(resource_or_scope)
  end

  helper_method :redirect_uri
  def redirect_uri
    @redirect_uri ||= begin
                        if params[:redirect_uri]
                          uri = URI.parse(params[:redirect_uri]).to_s
                          regex = /^.+\.#{request.domain.gsub('.', '\.')}/
                          uri =~ regex && uri
                        end
                      end
  end

  helper_method :redirect_uri?
  def redirect_uri?
    redirect_uri.present?
  end

  private

  def same_domain?(uri)
    return false unless uri

    uri = URI.parse(uri).to_s
    regex = /^.+\.#{request.domain.gsub('.', '\.')}/
    uri =~ regex
  end
end
