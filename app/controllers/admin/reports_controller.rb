class Admin::ReportsController < Admin::BaseController
  def daily_volume
    authorize :report, :daily_volume?

    @from = parse_date(params[:from]) || 30.days.ago.to_date
    @to   = parse_date(params[:to])   || Date.current

    @results = Dispute
      .where(opened_at: @from.beginning_of_day..@to.end_of_day)
      .group("DATE(opened_at)")
      .select(
        "DATE(opened_at) as day,
          COUNT(*) as dispute_count,
          SUM(amount_cents) as total_cents"
      )
  end

  def time_to_decision
    authorize :report, :time_to_decision?

    @results = Dispute
      .where(status: %w[won lost])
      .select(
        "DATE_TRUNC('week', opened_at) as week,
         PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY EXTRACT(EPOCH FROM (closed_at - opened_at))) as p50,
         PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY EXTRACT(EPOCH FROM (closed_at - opened_at))) as p90"
      )
      .group("DATE_TRUNC('week', opened_at)")
  end

  private

  def parse_date(value)
    Date.parse(value) if value.present?
  rescue ArgumentError
    nil
  end
end
