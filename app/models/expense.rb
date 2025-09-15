class Expense < ApplicationRecord
  belongs_to :creator, class_name: "User", foreign_key: "creator_id"

  belongs_to :category, optional: true
  belongs_to :user_group, optional: true

  has_many :expenses_users, dependent: :destroy
  has_many :payors, through: :expenses_users, source: :user

  has_many :payments, dependent: :destroy

  validates :title, presence: true, length: { maximum: 100 }
  validates :amount, presence: true, numericality: { greater_than: 0 }

  # Set default split type
  after_initialize :set_default_split_type, if: :new_record?

  private

  def set_default_split_type
    self.split_type ||= "equal"
  end
end
