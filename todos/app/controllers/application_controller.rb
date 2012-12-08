class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!

  def authenticate_user!
    logger.debug "TODO"
    logger.debug session.inspect
    logger.debug Marshal.load(Base64.decode64(cookies["_accounts_session"])).inspect
  end

  helper_method :current_user
  def current_user
    require 'ostruct'
    @current_user = OpenStruct.new
    @current_user.email = "foo@bar.com"

    @current_user
  end

  helper_method :user_signed_in?
  def user_signed_in?
    account_session.key?("warden.user.user.key")
  end

  helper_method :current_url
  def current_url
    "#{request.protocol}#{request.host_with_port}#{request.fullpath}"
  end

  helper_method :sign_up_url
  def sign_up_url
    "#{request.protocol}accounts.#{request.domain}#{request.port_string}/users/sign_up?redirect=#{Rack::Utils.escape(current_url)}"
  end

  helper_method :sign_in_url
  def sign_in_url
    "#{request.protocol}accounts.#{request.domain}#{request.port_string}/users/sign_in?redirect=#{Rack::Utils.escape(current_url)}"
  end

  helper_method :sign_out_url
  def sign_out_url
    "#{request.protocol}accounts.#{request.domain}#{request.port_string}/users/sign_out?redirect=#{Rack::Utils.escape(current_url)}"
  end

  private

  def account_session
    @account_session ||= Marshal.load(Base64.decode64(cookies["_accounts_session"]))
  end
end
