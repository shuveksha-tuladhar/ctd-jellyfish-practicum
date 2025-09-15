class UserGroup < ApplicationRecord
  belongs_to :creator, class_name: "User", foreign_key: :created_by_user_id

  has_many :group_members, dependent: :destroy
  has_many :users, through: :group_members

  has_many :expenses, dependent: :nullify

  has_many :payments, dependent: :destroy

  validates :name, presence: true
  validates :creator, presence: true

  after_create :add_creator_to_members

  private
  def add_creator_to_members
    group_members.find_or_create_by(user: creator)
  end
end
