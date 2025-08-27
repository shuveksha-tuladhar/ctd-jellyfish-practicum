require "rails_helper"

RSpec.describe "UserGroups", type: :request do
  let(:user) do
    User.create!(
      first_name: "John",
      last_name: "Doe",
      email: "john@example.com",
      password: "password",
      phone_number: "2342341234"
    )
  end

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  describe "GET /index" do
    it "returns http success" do
      get user_groups_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    let(:group) { UserGroup.create!(name: "Trip", description: "Vacation", creator: user) }

    it "returns http success" do
      get user_group_path(group)
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /create" do
    it "creates a new group" do
      expect {
        post user_groups_path, params: { user_group: { name: "New Group", description: "Test group" } }
      }.to change(UserGroup, :count).by(1)

      # Optional: verify creator is set correctly
      new_group = UserGroup.last
      expect(new_group.creator).to eq(user)
      expect(new_group.name).to eq("New Group")
    end
  end

  describe "PATCH /update" do
    let(:group) { UserGroup.create!(name: "Trip", description: "Vacation", creator: user) }

    it "updates the group" do
      patch user_group_path(group), params: { user_group: { name: "Updated Name" } }
      group.reload
      expect(group.name).to eq("Updated Name")
    end
  end

  describe "DELETE /destroy" do
    let!(:group) { UserGroup.create!(name: "Trip", description: "Vacation", creator: user) }

    it "deletes the group" do
      expect {
        delete user_group_path(group)
      }.to change(UserGroup, :count).by(-1)
    end
  end
end
