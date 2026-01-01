User.find_or_create_by!(email: "demouser@example.com") do |user|
  user.first_name = "John"
  user.last_name = "Doe"
  user.phone_number = "1234567890"
  user.password = "password"
  user.password_confirmation = "password"
end

puts "John Doe created successfully!"

User.find_or_create_by!(email: "harrypotter@example.com") do |user|
    user.first_name = "Harry"
    user.last_name = "Potter"
    user.phone_number = "9876543210"
    user.password = "password"
    user.password_confirmation = "password"
end

puts "Harry Potter created successfully!"

User.find_or_create_by!(email: "hermionegranger@example.com") do |user|
    user.first_name = "Hermione"
    user.last_name = "Granger"
    user.phone_number = "5551234567"
    user.password = "password"
    user.password_confirmation = "password"
end

puts "Hermione Granger created successfully!"
