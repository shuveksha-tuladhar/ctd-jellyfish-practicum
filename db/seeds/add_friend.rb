# Find users
john = User.find_by!(email: 'demouser@example.com')
harry = User.find_by!(email: 'harrypotter@example.com')
hermione = User.find_by!(email: 'hermionegranger@example.com')

# Add John as friend to Harry
Friendship.find_or_create_by!(user: john, friend: harry)

# Add John as friend to Hermione
Friendship.find_or_create_by!(user: john, friend: hermione)

puts "Added Harry Potter and Hermione Granger as a friend to John Doe"
