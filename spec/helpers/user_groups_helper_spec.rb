require "rails_helper"

RSpec.describe UserGroupsHelper, type: :helper do
  let(:creator) do
    User.create!(
      first_name: "John",
      last_name: "Doe",
      email: "john@example.com",
      password: "password",
      phone_number: "1234567890"
    )
  end

  let(:group) { UserGroup.create!(name: "Test Group", creator: creator) }

  describe "#group_member_count" do
    it "returns the number of members in a group" do
      group.group_members.create!(user: creator)
      expect(helper.group_member_count(group)).to eq(1)
    end
  end

  describe "#group_creator_name" do
    it "returns the full name of the group creator" do
      expect(helper.group_creator_name(group)).to eq("John Doe")
    end
  end
end
