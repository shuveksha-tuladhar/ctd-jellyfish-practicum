require "rails_helper"

RSpec.describe UserGroupsHelper, type: :helper do
  let(:creator) { create(:user) }
  let(:group)   { create(:user_group, creator: creator) }

  describe "#group_member_count" do
    it "returns the number of members in a group" do
      create(:group_member, user_group: group, user: creator)
      expect(helper.group_member_count(group)).to eq(1)
    end
  end

  describe "#group_creator_name" do
    it "returns the full name of the group creator" do
      expect(helper.group_creator_name(group)).to eq("#{creator.first_name} #{creator.last_name}")
    end
  end
end
