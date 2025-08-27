require "rails_helper"

RSpec.describe UserGroup, type: :model do
  let(:user) do
    User.create!(
      first_name: "John",
      last_name: "Doe",
      email: "john@example.com",
      password: "password",
      phone_number: "2341231234"
    )
  end

  subject do
    described_class.new(
      name: "Trip to NYC",
      description: "Vacation group",
      creator: user
    )
  end

  describe "validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without a name" do
      subject.name = nil
      expect(subject).not_to be_valid
    end

    it "is not valid without a creator" do
      subject.creator = nil
      expect(subject).not_to be_valid
    end
  end

  describe "associations" do
    it "belongs to a creator" do
      expect(subject.creator).to eq(user)
    end

    it "has many group_members" do
      gm1 = GroupMember.create!(user: user, user_group: subject)
      gm2 = GroupMember.create!(user: user, user_group: subject)
      expect(subject.group_members).to include(gm1, gm2)
    end

    it "has many users through group_members" do
      user2 = User.create!(first_name: "Jane", last_name: "Smith", email: "jane@example.com", password: "password", phone_number: "5555555555")
      gm = GroupMember.create!(user: user2, user_group: subject)
      expect(subject.users).to include(user2)
    end

    it "destroys dependent group_members when destroyed" do
      gm = GroupMember.create!(user: user, user_group: subject)
      subject.save!
      expect { subject.destroy }.to change { GroupMember.count }.by(-1)
    end
  end
end
