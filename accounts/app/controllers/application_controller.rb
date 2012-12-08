class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!

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
    params[:redirect]
  end

  helper_method :redirect_url?
  def redirect_url?
    params.key?(:redirect)
  end
end
