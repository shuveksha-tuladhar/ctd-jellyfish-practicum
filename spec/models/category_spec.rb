require 'rails_helper'

RSpec.describe Category, type: :model do
  describe "validations" do
    it "is valid with a name" do
      category = build(:category)
      expect(category).to be_valid
    end

    it "is invalid without a name" do
      category = build(:category, name: nil)
      expect(category).not_to be_valid
    end
  end

  describe "associations" do
    it "has many expenses" do
      category = create(:category)
      user = create(:user)
      user_group = create(:user_group, creator: user)


      expense = create(:expense, user: user, category: category, user_group: user_group)

      expect(category.expenses).to include(expense)
    end
  end
end
