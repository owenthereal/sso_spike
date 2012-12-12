class Oauth2ProviderCreateTables < ActiveRecord::Migration
  def up
    Songkick::OAuth2::Model::Schema.up
  end

  def down
  end
end
