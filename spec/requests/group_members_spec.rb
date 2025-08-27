require "rails_helper"

RSpec.describe "GroupMembers", type: :request do
  let!(:user) { User.create!(first_name: "John", last_name: "Doe", email: "john@example.com", phone_number: "1234567890", password: "password") }
  let!(:group) { UserGroup.create!(name: "Test Group", creator: user) }

  before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user) }

  describe "GET /user_groups/:user_group_id/group_members" do
    it "returns http success and lists members" do
      get user_group_group_members_path(group)
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /user_groups/:user_group_id/group_members" do
    let!(:new_member) { User.create!(first_name: "Jane", last_name: "Smith", email: "jane@example.com", phone_number: "0987654321", password: "password") }

    it "adds a new member to the group" do
      expect {
        post user_group_group_members_path(group), params: { group_member: { user_id: new_member.id } }
      }.to change { GroupMember.count }.by(1)
    end
  end

  describe "DELETE /user_groups/:user_group_id/group_members/:id" do
    let!(:member) { User.create!(first_name: "Alice", last_name: "Brown", email: "alice@example.com", phone_number: "5555555555", password: "password") }
    let!(:group_member) { GroupMember.create!(user_group: group, user: member) }

    it "removes a member from the group" do
      expect {
        delete user_group_group_member_path(group, group_member)
      }.to change { GroupMember.count }.by(-1)
    end
  end
end
