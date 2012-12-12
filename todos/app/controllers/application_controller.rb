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
    require "net/http"

    uri = URI.parse("#{accounts_url}/api/user.json?oauth_token=#{CGI.escape(auth_token)}")
    user_resp = Net::HTTP.get_response(uri)

    logger.debug user_resp.inspect

    require 'ostruct'
    @current_user = OpenStruct.new
    @current_user.email = JSON.parse(user_resp.body)["email"]

    @current_user
  end

  helper_method :user_signed_in?
  def user_signed_in?
    accounts_cookies.key?("warden.user.user.key") && accounts_cookies.key?("auth_token")
  end

  helper_method :current_url
  def current_url
    "#{request.protocol}#{request.host_with_port}#{request.fullpath}"
  end

  def client_id
    "f59cjzzfeenjmajyoeumij4u2lzu5up"
  end

  def client_secret
    "ocupa8rxouqs2oocdi88qken6oqzruk"
  end

  def auth_token
    accounts_cookies["auth_token"]
  end

  helper_method :sign_up_url
  def sign_up_url
    accounts_auth_url_for(:sign_up)
  end

  helper_method :sign_in_url
  def sign_in_url
    accounts_auth_url_for(:sign_in)
  end

  helper_method :sign_out_url
  def sign_out_url
    "#{request.protocol}accounts.#{request.domain}#{request.port_string}/users/sign_out?redirect_uri=#{current_url}"
  end

  private

  def accounts_auth_url_for(path)
    "#{accounts_url}/users/#{path}?redirect_uri=#{current_url}&client_id=#{client_id}&response_type=code"
  end

  def accounts_url
    "#{request.protocol}accounts.#{request.domain}#{request.port_string}"
  end

  def accounts_cookies
    @accounts_cookies ||= Marshal.load(Base64.decode64(cookies["_accounts_session"]))
  end
end
