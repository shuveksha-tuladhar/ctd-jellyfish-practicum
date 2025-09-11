require "rails_helper"

RSpec.describe UserGroupsHelper, type: :helper do
  let(:creator) { create(:user) }
  let(:group) { create(:user_group, creator: creator) }

  describe "#group_member_count" do
    it "returns 1 when only the creator is a member" do
      expect(helper.group_member_count(group)).to eq(1)
    end

    it "returns correct count with additional members" do
      user2 = create(:user)
      user3 = create(:user)
      create(:group_member, user_group: group, user: user2)
      create(:group_member, user_group: group, user: user3)

      expect(helper.group_member_count(group)).to eq(3)
    end
  end

  describe "#group_creator_name" do
    it "returns full name of creator" do
      expect(helper.group_creator_name(group))
        .to eq("#{creator.first_name} #{creator.last_name}")
    end
  end
end
