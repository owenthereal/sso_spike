admin = User.create!(email: "admin@acl.com", password: "secret", password_confirmation: "secret")
client = Client.create!(name: "Todos app", redirect_uri: "http://todos.aclcloud.dev/", owner: admin)

puts "URI: #{client.redirect_uri}"
puts "Client id: #{client.client_id}"
puts "Client secret: #{client.client_secret}"

client = Client.create!(name: "another Todos app", redirect_uri: "http://anothertodos.aclcloud.dev/", owner: admin)

puts "URI: #{client.redirect_uri}"
puts "Client id: #{client.client_id}"
puts "Client secret: #{client.client_secret}"
