class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  before_filter :print_session

  def print_session
    logger.debug session.inspect
  end

  def after_sign_in_path_for(resource_or_scope)
    grant_access
    redirect_uri || super(resource_or_scope)
  end

  def after_sign_out_path_for(resource_or_scope)
    revoke_access
    redirect_uri || super(resource_or_scope)
  end

  def after_sign_up_path_for(resource_or_scope)
    grant_access

    redirect_uri || super(resource_or_scope)
  end

  helper_method :oauth
  def oauth
    @oauth ||= Songkick::OAuth2::Provider.parse(current_user, request)
  end

  private

  def grant_access
    if user_signed_in?
      oauth.valid?
      logger.debug oauth.inspect

      if oauth.valid? && same_domain?(oauth.redirect_uri)
        oauth.grant_access!
        cookies[cookies_name_for(oauth.redirect_uri)] = {
          value: oauth.code,
          domain: :all
        }
      else
        oauth.deny_access!
        cookies.delete(cookies_name_for(oauth.redirect_uri), domain: :all)
      end
    end
  end

  def revoke_access
    cookies.each do |k, v|
      cookies.delete(k, domain: :all) if k =~ /^__.+/
    end
  end

  def redirect_uri
    @redirect_uri ||= begin
                        result = oauth.valid? ? oauth.client.redirect_uri : nil
                        result ||= params[:redirect_uri] && same_domain?(params[:redirect_uri]) ? params[:redirect_uri] : nil

                        if result
                          result = "#{result}?code=#{oauth.code}" if oauth.code
                          result = "#{result}&state=#{params[:state]}" if params[:state]
                        end

                        result
                      end
  end


  def same_domain?(uri)
    return false unless uri

    uri = URI.parse(uri).to_s
    regex = /^.+\.#{request.domain.gsub('.', '\.')}/
    uri =~ regex
  end

  def cookies_name_for(uri)
    "__#{URI.parse(uri).host}"
  end
end
