require "rails_helper"

RSpec.describe SplitCalculator, type: :service do
  let!(:alice) { create(:user, first_name: "Alice") }
  let!(:bob)   { create(:user, first_name: "Bob") }
  let!(:carol) { create(:user, first_name: "Carol") }

  def build_splits_data(participants, percentages)
    raise "participants and percentages size mismatch" unless participants.size == percentages.size

    participants.each_with_index.map do |participant, i|
      { participant_id: participant.id, percentage: percentages[i] }
    end
  end

  describe "#call" do
    context "equal split between individuals" do
      it "splits the amount evenly and adjusts payer for rounding" do
        expense = create(:expense, title: "Dinner", amount: 100.01, user: alice)
        participants = [ alice, bob, carol ]

        result = SplitCalculator.new(expense, split_type: :equal, participants: participants).call

        expect(result[:expense_id]).to eq(expense.id)

        total_share = BigDecimal(result[:splits].sum { |s| s[:share] }.to_s)
        expect(total_share).to be_within(0.01).of(expense.amount.to_d)

        alice_split = result[:splits].find { |s| s[:participant_id] == alice.id }
        expect(alice_split[:share]).to be_within(0.01).of(33.34)

        bob_split = result[:splits].find { |s| s[:participant_id] == bob.id }
        carol_split = result[:splits].find { |s| s[:participant_id] == carol.id }

        expect(bob_split[:share]).to be_within(0.01).of(33.33)
        expect(carol_split[:share]).to be_within(0.01).of(33.33)
      end
    end

    context "percentage split between individuals" do
      it "calculates shares based on percentages and adjusts payer for rounding" do
        expense = create(:expense, :percentage_split, amount: 50.99, user: bob)
        splits_data = build_splits_data([ bob, carol ], [ 60, 40 ])

        result = SplitCalculator.new(expense, split_type: :percentage, splits_data: splits_data, participants: [ bob, carol ]).call

        expect(result[:expense_id]).to eq(expense.id)

        total_share = BigDecimal(result[:splits].sum { |s| s[:share] }.to_s)
        expect(total_share).to be_within(0.01).of(expense.amount.to_d)

        bob_split = result[:splits].find { |s| s[:participant_id] == bob.id }
        carol_split = result[:splits].find { |s| s[:participant_id] == carol.id }

        expect(bob_split[:share]).to be_within(0.01).of(30.59)
        expect(carol_split[:share]).to be_within(0.01).of(20.40)
      end

      it "raises error if splits_data is missing" do
        expense = create(:expense, :percentage_split, amount: 50.0, user: bob)

        expect {
          SplitCalculator.new(expense, split_type: :percentage, participants: [ bob, carol ]).call
        }.to raise_error("splits_data required for percentage split")
      end
    end

    context "equal split using group members" do
      it "splits amount among all group members automatically" do
        group = create(:user_group, creator: alice)
        create(:group_member, user: bob,   user_group: group)
        create(:group_member, user: carol, user_group: group)

        expense = create(:expense, title: "Team Lunch", amount: 99.99, user: alice, user_group: group)

        result = SplitCalculator.new(expense, split_type: :equal).call

        expect(result[:expense_id]).to eq(expense.id)

        total_share = BigDecimal(result[:splits].sum { |s| s[:share] }.to_s)
        expect(total_share).to be_within(0.01).of(expense.amount.to_d)

        alice_split = result[:splits].find { |s| s[:participant_id] == alice.id }
        bob_split   = result[:splits].find { |s| s[:participant_id] == bob.id }
        carol_split = result[:splits].find { |s| s[:participant_id] == carol.id }

        expect(alice_split[:share]).to be_within(0.02).of(33.34)
        expect(bob_split[:share]).to be_within(0.01).of(33.33)
        expect(carol_split[:share]).to be_within(0.01).of(33.33)
      end
    end

    context "percentage split using group members" do
      it "calculates shares based on percentages for all group members" do
        group = create(:user_group, creator: alice)
        create(:group_member, user: bob,   user_group: group)
        create(:group_member, user: carol, user_group: group)

        expense = create(:expense, :percentage_split, amount: 120.0, user: alice, user_group: group)

        splits_data = build_splits_data([ alice, bob, carol ], [ 50, 30, 20 ])

        result = SplitCalculator.new(expense, split_type: :percentage, splits_data: splits_data).call

        expect(result[:expense_id]).to eq(expense.id)

        total_share = BigDecimal(result[:splits].sum { |s| s[:share] }.to_s)
        expect(total_share).to be_within(0.01).of(expense.amount.to_d)

        alice_split = result[:splits].find { |s| s[:participant_id] == alice.id }
        bob_split   = result[:splits].find { |s| s[:participant_id] == bob.id }
        carol_split = result[:splits].find { |s| s[:participant_id] == carol.id }

        expect(alice_split[:share]).to be_within(0.01).of(60.0)
        expect(bob_split[:share]).to be_within(0.01).of(36.0)
        expect(carol_split[:share]).to be_within(0.01).of(24.0)
      end

      it "raises error if splits_data is missing for group" do
        group = create(:user_group, creator: alice)
        create(:group_member, user: bob,   user_group: group)

        expense = create(:expense, :percentage_split, amount: 80.0, user: alice, user_group: group)

        expect {
          SplitCalculator.new(expense, split_type: :percentage).call
        }.to raise_error("splits_data required for percentage split")
      end
    end
  end
end
