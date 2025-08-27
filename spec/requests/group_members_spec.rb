require "rails_helper"

RSpec.describe "GroupMembers", type: :request do
  let(:user) do
    User.create!(
      first_name: "John",
      last_name: "Doe",
      email: "john@example.com",
      password: "password",
      phone_number: "1231233214"
    )
  end

  let(:group) do
    UserGroup.create!(
      name: "Trip",
      description: "Vacation",
      creator: user
    )
  end

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  describe "POST /create" do
    it "adds a member to the group" do
      expect {
        post group_members_path, params: { group_member: { user_id: user.id, user_group_id: group.id } }
      }.to change(GroupMember, :count).by(1)

      member = GroupMember.last
      expect(member.user).to eq(user)
      expect(member.user_group).to eq(group)
    end
  end

  describe "DELETE /destroy" do
    let!(:member) { GroupMember.create!(user: user, user_group: group) }

    it "removes a member from the group" do
      expect {
        delete group_member_path(member)
      }.to change(GroupMember, :count).by(-1)
    end
  end
end
