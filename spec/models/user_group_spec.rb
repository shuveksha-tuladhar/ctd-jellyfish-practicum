require "rails_helper"

RSpec.describe UserGroup, type: :model do
  let(:creator) { create(:user) }
  subject { build(:user_group, creator: creator) }

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
      expect(subject.creator).to eq(creator)
    end

    it "adds creator as a member after creation" do
      subject.save!
      expect(subject.users).to include(creator)
    end

    it "can have additional members" do
      subject.save!
      user2 = create(:user)
      create(:group_member, user_group: subject, user: user2)
      expect(subject.users).to include(user2)
    end

    it "destroys all dependent group_members when destroyed" do
      subject.save!
      user2 = create(:user)
      create(:group_member, user_group: subject, user: user2)

      expect { subject.destroy }.to change { GroupMember.count }.by(-2)
    end
  end
end
