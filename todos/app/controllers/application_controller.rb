class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!

  def authenticate_user!
    logger.debug "TODO"
    logger.debug session.inspect
    logger.debug cookies.inspect
    logger.debug Marshal.load(Base64.decode64(cookies["_accounts_session"])).inspect
  end

  helper_method :current_user
  def current_user
    @current_user ||= begin
                        require 'ostruct'
                        current_user = OpenStruct.new
                        current_user.email = session[:user_email]
                        current_user

                        #if code
                          #require "net/http"
                          #uri = URI.parse("#{accounts_url}/login/oauth/access_token.json")
                          #resp = Net::HTTP.post_form(uri, {
                            #client_id: client_id,
                            #client_secret: client_secret,
                            #code: code
                          #})
                          #logger.debug resp.inspect

                          #access_token = JSON.parse(resp.body)["access_token"]
                          #uri = URI.parse("#{accounts_url}/api/user.json?oauth_token=#{CGI.escape(access_token)}")
                          #resp = Net::HTTP.get_response(uri)

                          #logger.debug resp.inspect
                          #current_user.email = JSON.parse(resp.body)["email"]
                        #else
                          #current_user.email = "unknown"
                        #end
                      end
  end

  helper_method :user_signed_in?
  def user_signed_in?
    accounts_cookies.key?("warden.user.user.key") && code.present?
  end

  helper_method :current_url
  def current_url
    "#{request.protocol}#{request.host_with_port}#{request.fullpath}"
  end

  def client_id
    "acf1w3kf3m7lly7dl9butsqq1tnwuku"
  end

  def client_secret
    "1ahq4vaqzezwejl1t23ukolvv64szrk"
  end

  helper_method :sign_up_url
  def sign_up_url
    accounts_auth_url_for(:sign_up)
  end

  helper_method :sign_in_url
  def sign_in_url
    "/auth/acl"
  end

  helper_method :sign_out_url
  def sign_out_url
    "#{request.protocol}accounts.#{request.domain}#{request.port_string}/users/sign_out?redirect_uri=#{current_url}"
  end

  private

  def code
    share_cookies
  end

  def accounts_auth_url_for(path)
    "#{accounts_url}/users/#{path}?redirect_uri=#{current_url}&client_id=#{client_id}&response_type=code"
  end

  def accounts_url
    "#{request.protocol}accounts.#{request.domain}#{request.port_string}"
  end

  def accounts_cookies
    @accounts_cookies ||= Marshal.load(Base64.decode64(cookies[accounts_cookies_name])) if cookies[accounts_cookies_name]
  end

  def share_cookies
    @share_cookies ||= cookies[share_cookies_name]
  end

  def accounts_cookies_name
    "_accounts_session"
  end

  def share_cookies_name
    "__#{request.host_with_port}"
  end
end
