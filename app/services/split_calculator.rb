class SplitCalculator
  require "bigdecimal"
  require "bigdecimal/util"

  # split_type: :equal or :percentage
  # splits_data: required only for :percentage, array of hashes [{participant_id:, percentage:}]
  def initialize(expense, split_type: :equal, splits_data: nil, participants: nil)
    @expense = expense
    @payer = expense.creator
    @amount = expense.amount.to_d

    @participants =
      if participants.present?
        participants
      elsif expense.user_group.present?
        expense.user_group.users
      else
        [ @payer ]
      end

    @split_type = split_type
    @splits_data = splits_data
  end

  def call
    {
      expense_id: @expense.id,
      splits: calculate_splits
    }
  end

  private

  def calculate_splits
    case @split_type
    when :equal
      equal_split
    when :percentage
      percentage_split
    else
      raise "Invalid split_type"
    end
  end

  def equal_split
    num_participants = @participants.size

    # Convert total amount to cents to avoid float rounding errors
    total_cents = (@amount * 100).to_i
    base_share_cents = total_cents / num_participants
    remainder = total_cents % num_participants

    splits = @participants.map do |p|
      share_cents = base_share_cents
      # Give leftover cents to payer
      share_cents += remainder if p.id == @payer.id
      { participant_id: p.id, share: (share_cents.to_d / 100).round(2) }
    end

    splits.each { |s| s[:share] = s[:share].to_f }
    splits
  end

  def percentage_split
    raise "splits_data required for percentage split" unless @splits_data.present?

    splits = @splits_data.map do |data|
      participant = @participants.find { |p| p.id == data[:participant_id] }
      raise "Invalid participant_id #{data[:participant_id]}" unless participant

      share = (@amount * data[:percentage].to_d / 100).round(2)
      { participant_id: participant.id, share: BigDecimal(share.to_s) }
    end

    adjust_payer_share(splits)
  end

  def adjust_payer_share(splits)
    # Total assigned before adjustment
    total_assigned = splits.sum { |s| BigDecimal(s[:share].to_s) }
    rounding_difference = (@amount - total_assigned).round(2)

    # Add leftover to payer if included in participants, otherwise first participant
    payer_split = splits.find { |s| s[:participant_id] == @payer.id } || splits.first
    payer_split[:share] = (BigDecimal(payer_split[:share].to_s) + rounding_difference).round(2)

    # Convert all shares to float for consistency
    splits.each { |s| s[:share] = s[:share].to_f }

    splits
  end
end
