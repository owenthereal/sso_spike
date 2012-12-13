module Login
  class OauthController < ActionController::Base
    def access_token
      if (client = validate_client(params[:client_id,], params[:client_secret])) \
        && (authorization = validate_code(client, params[:code])) \
        && (req = request_for(request.env, client.redirect_uri)) \
        && (auth = validate_authorization(authorization.owner, req))

        resp_hash = response_hash(auth.response_body)

        respond_to do |format|
          format.html { render text: to_text(resp_hash), content_type: "application/x-www-form-urlencoded" }
          format.json { render json: resp_hash, content_type: "application/json" }
        end
      else
        error_msg = "Credentials are invalid"

        respond_to do |format|
          format.html { render text: error_msg, status: :unauthorized, content_type: "application/x-www-form-urlencoded" }
          format.json { render json: { error: error_msg }, status: :unauthorized, content_type: "application/json" }
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
      auth = client.authorizations.where(code: params[:code]).first
      logger.debug "Can't find authorization for #{code}" unless auth

      auth
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
        logger.debug "Invalid request: #{auth.inspect}"
        nil
      end
    end

    def response_hash(body)
      json = JSON.parse(body)
      #json[:token_type] = "bearer"

      json
    end

    def to_text(hash)
      hash.map { |k, v| "#{k}=#{v}" }.join("&")
    end
  end
end
