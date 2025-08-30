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

    it "has many group_members" do
      subject.save!
      gm1 = create(:group_member, user_group: subject)
      gm2 = create(:group_member, user_group: subject)
      expect(subject.group_members).to include(gm1, gm2)
    end

    it "has many users through group_members" do
      subject.save!
      user2 = create(:user)
      gm = create(:group_member, user_group: subject, user: user2)
      expect(subject.users).to include(user2)
    end

    it "destroys dependent group_members when destroyed" do
      subject.save!
      gm = create(:group_member, user_group: subject)
      expect { subject.destroy }.to change { GroupMember.count }.by(-1)
    end
  end
end
