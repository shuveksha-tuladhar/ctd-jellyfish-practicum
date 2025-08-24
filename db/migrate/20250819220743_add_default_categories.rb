class AddDefaultCategories < ActiveRecord::Migration[8.0]
  def up
    categories = [
      "Food & Dining",
      "Transportation",
      "Entertainment",
      "Utilities",
      "Healthcare",
      "Education",
      "Travel",
      "Rent",
      "Miscellaneous"
    ]

    categories.each do |name|
      Category.create!(name: name)
    end
  end

  def down
    Category.delete_all
  end
end
