class SplitCalculator
  require "bigdecimal"
  require "bigdecimal/util"

  def initialize(expense, participants: nil)
    @expense = expense
    @payer = expense.user
    @amount = expense.amount.to_d

    # Determine participants
    @participants =
      if participants.present?
        participants
      elsif expense.user_group.present?
        expense.user_group.users
      else
        [@payer]
      end
  end

  def call
    {
      expense_id: @expense.id,
      splits: equal_split
    }
  end

  private

  def equal_split
    num_participants = @participants.size
    share = (@amount / num_participants).round(2)

    splits = @participants.map do |participant|
      { participant_id: participant.id, share: share.to_f }
    end

    # Adjust payer's share to cover rounding differences
    total_assigned = splits.sum { |s| BigDecimal(s[:share].to_s) }
    rounding_difference = (@amount - total_assigned).round(2)

    payer_split = splits.find { |s| s[:participant_id] == @payer.id }
    if payer_split
      payer_split[:share] = (BigDecimal(payer_split[:share].to_s) + rounding_difference).round(2).to_f
    end

    splits.each { |s| s[:share] = s[:share].to_f }

    splits
  end
end
