class ReportPolicy < ApplicationPolicy
  def daily_volume?
    user.present?
  end

  def time_to_decision?
    user.present?
  end
end
