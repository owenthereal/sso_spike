OmniAuth.config.logger = Rails.logger

require 'omniauth/strategies/acl'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :acl, "acf1w3kf3m7lly7dl9butsqq1tnwuku", "1ahq4vaqzezwejl1t23ukolvv64szrk"
end
