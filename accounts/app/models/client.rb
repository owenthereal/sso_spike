class Client
  def self.create!(args = {})
    client = Songkick::OAuth2::Model::Client.new(name: args[:name], redirect_uri: args[:redirect_uri])
    client.owner = args[:owner] if args[:owner]

    client.tap(&:save!)
  end
end
