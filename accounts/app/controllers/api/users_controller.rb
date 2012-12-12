module Api
  class UsersController < ::Api::ApplicationController
    def current
      render json: current_user
    end
  end
end
