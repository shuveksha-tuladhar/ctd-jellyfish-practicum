john = User.find_by!(email: 'demouser@example.com')

# friends
harrypotter = User.find_by!(email: 'harrypotter@example.com')
hermione = User.find_by!(email: 'hermionegranger@example.com')

# Create expenses
# ----------------------------------------------------------------
# Equal split expenses
# ----------------------------------------------------------------
expense1 = Expense.create!(
    title: 'Dinner at Restaurant',
    amount: 120.00,
    split_type: 'equal',
    category: Category.find_by!(name: 'Food & Dining'),
    created_at: Date.today - 2.days,
    creator: john
)

ExpenseUser.create!(user: john, expense: expense1)
ExpenseUser.create!(user: harrypotter, expense: expense1)
ExpenseUser.create!(user: hermione, expense: expense1)

expense2 = Expense.create!(
    title: 'Movie Tickets',
    amount: 45.00,
    split_type: 'equal',
    category: Category.find_by!(name: 'Entertainment'),
    created_at: Date.today - 5.days,
    creator: john
)

ExpenseUser.create!(user: john, expense: expense2)
ExpenseUser.create!(user: harrypotter, expense: expense2)

Expense.create!(
    title: 'Grocery Shopping',
    amount: 80.00,
    split_type: 'equal',
    category: Category.find_by!(name: 'Food & Dining'),
    created_at: Date.today - 1.day,
    creator: john
)

ExpenseUser.create!(user: john, expense: Expense.last)
ExpenseUser.create!(user: hermione, expense: Expense.last)

puts "Created #{Expense.count} expenses with equal splits"

# ----------------------------------------------------------------
# End of Equal split expenses
# ----------------------------------------------------------------

# ----------------------------------------------------------------
# Equal split expenses in a group
# ----------------------------------------------------------------
group = UserGroup.find_by!(name: 'Fun Group')
expense3 = Expense.create!(
    title: 'Group Outing',
    amount: 300.00,
    split_type: 'equal',
    category: Category.find_by!(name: 'Entertainment'),
    user_group: group,
    created_at: Date.today - 3.days,
    creator: john
)
ExpenseUser.create!(user: john, expense: expense3)

puts "Created #{Expense.count} expenses in a group"
# ----------------------------------------------------------------
# End of Equal split expenses in a group
# ----------------------------------------------------------------

# ----------------------------------------------------------------
# Unequal split expenses
# ----------------------------------------------------------------
expense4 = Expense.create!(
    title: 'Lunch at Cafe',
    amount: 200.00,
    split_type: 'percentage',
    category: Category.find_by!(name: 'Food & Dining'),
    created_at: Date.today - 4.days,
    creator: john
)

ExpenseUser.create!(user: john, expense: expense4)
ExpenseUser.create!(user: harrypotter, expense: expense4)
ExpenseUser.create!(user: hermione, expense: expense4)

ExpenseSplit.create!(expense: expense4, user: john, percentage_split: 50.0)
ExpenseSplit.create!(expense: expense4, user: harrypotter, percentage_split: 30.0)
ExpenseSplit.create!(expense: expense4, user: hermione, percentage_split: 20.0)

puts "Created #{Expense.count} expenses with some unequal splits"
# ----------------------------------------------------------------
# End of Unequal split expenses
# ----------------------------------------------------------------
