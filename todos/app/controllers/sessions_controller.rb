class SessionsController < ApplicationController
  def create
    session[:user_email] = auth_hash["info"]["email"]
    logger.debug auth_hash.inspect

    redirect_to root_path
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
