admin = User.create!(email: "admin@acl.com", password: "secret", password_confirmation: "secret")
client = Client.create!(name: "Todos app", redirect_uri: "http://todos.acl.dev/", owner: admin)

puts "Client id: #{client.client_id}"
puts "Client secret: #{client.client_secret}"
