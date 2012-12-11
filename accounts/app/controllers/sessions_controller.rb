class SessionsController < Devise::SessionsController
  def new
    @oauth2 = Songkick::OAuth2::Provider.parse(current_user, request)
    super
  end

  def create
    super
  end
end
