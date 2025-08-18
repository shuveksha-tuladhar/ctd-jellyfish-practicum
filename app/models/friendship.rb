class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: "User"

  # user has unique friend
  validates :friend_id, uniqueness: { scope: :user_id, message: "friendship already exists" }
end
