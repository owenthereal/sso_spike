class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  before_filter :print_session

  def print_session
    logger.debug session.inspect
  end

  def after_sign_in_path_for(resource_or_scope)
    redirect_url || super(resource_or_scope)
  end

  def after_sign_out_path_for(resource_or_scope)
    redirect_url || super(resource_or_scope)
  end

  def after_sign_up_path_for(resource_or_scope)
    redirect_url || super(resource_or_scope)
  end

  helper_method :redirect_url
  def redirect_url
    @redirect_url ||= begin
                        uri = URI.parse(params[:redirect]).to_s
                        regex = /^.+\.#{request.domain.gsub('.', '\.')}/
                        uri =~ regex && uri
                      end
  end

  helper_method :redirect_url?
  def redirect_url?
    redirect_url.present?
  end
end
