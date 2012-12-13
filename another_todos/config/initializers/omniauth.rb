OmniAuth.config.logger = Rails.logger

require 'omniauth/strategies/acl'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :acl, "mmhx6ugzrokogw6od2sl5k2smlbya2x", "ioruayvoxo3ffafv6iwzsik16720c6t"
end
