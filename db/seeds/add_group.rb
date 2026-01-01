# Create users
john = User.find_by!(email: 'demouser@example.com')
harry = User.find_by!(email: 'harrypotter@example.com')
hermione = User.find_by!(email: 'hermionegranger@example.com')

# Create group
group = UserGroup.create!(
    name: 'Fun Group',
    creator: john
)

# Add members to group
[ john, harry, hermione ].each do |user|
    GroupMember.create!(
        user: user,
        user_group: group,
    )
end

puts "Created group '#{group.name}' with #{group.users.count} members"
