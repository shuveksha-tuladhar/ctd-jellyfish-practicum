categories = [
    'Food & Dining',
    'Transportation',
    'Entertainment',
    'Utilities',
    'Healthcare',
    'Education',
    'Travel',
    'Rent',
    'Miscellaneous'
]

categories.each do |name|
    Category.find_or_create_by!(name: name)
end

puts "Created #{categories.count} categories"