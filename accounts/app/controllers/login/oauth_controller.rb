module Login
  class OauthController < ActionController::Base
    def access_token
      if (client = validate_client(params[:client_id,], params[:client_secret])) \
        && (authorization = validate_code(client, params[:code])) \
        && (req = request_for(request.env, client.redirect_uri)) \
        && (auth = validate_authorization(authorization.owner, req))

        resp_hash = response_hash(auth.access_token)

        respond_to do |format|
          format.html { render text: to_text(resp_hash) }
          format.json { render json: resp_hash }
        end
      else
        error_msg = "Credentials are invalid"

        respond_to do |format|
          format.html { render text: error_msg, status: :unauthorized }
          format.json { render json: { error: error_msg }, status: :unauthorized }
        end
      end
    end

    private

    def validate_client(client_id, client_secret)
      client = Songkick::OAuth2::Model::Client.where(client_id: params[:client_id]).first
      if client && client.valid_client_secret?(params[:client_secret])
        client
      else
        nil
      end
    end

    def validate_code(client, code)
      client.authorizations.where(code: params[:code]).first
    end

    def request_for(env, redirect_uri)
      Rack::Request.new(env).tap do |req|
        req.POST["redirect_uri"] = redirect_uri
        req.POST["response_type"] = "token"
      end
    end

    def validate_authorization(user, req)
      auth = Songkick::OAuth2::Provider.parse(user, req)
      if auth.valid?
        auth
      else
        nil
      end
    end

    def response_hash(access_token)
      { access_token: access_token, token_type: "bearer"}
    end

    def to_text(hash)
      hash.map { |k, v| "#{k}=#{v}" }.join("&")
    end
  end
end
