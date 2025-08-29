require "rails_helper"

RSpec.describe "GroupMembers", type: :request do
  let!(:user) { create(:user) }
  let!(:group) { create(:user_group, creator: user) }
  let!(:new_member) { create(:user) }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  describe "POST /user_groups/:user_group_id/group_members" do
    it "adds a member to the group" do
      expect {
        post user_group_group_members_path(group), params: { group_member: { user_id: new_member.id } }
      }.to change { GroupMember.count }.by(1)

      member = GroupMember.last
      expect(member.user).to eq(new_member)
      expect(member.user_group).to eq(group)
    end
  end

  describe "DELETE /user_groups/:user_group_id/group_members/:id" do
    let!(:group_member) { create(:group_member, user_group: group, user: new_member) }

    it "removes a member from the group" do
      expect {
        delete user_group_group_member_path(group, group_member)
      }.to change { GroupMember.count }.by(-1)
    end
  end
end
