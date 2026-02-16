class WebhookProcessorJob < ApplicationJob
  queue_as :default

  def perform(payload)
    return if WebhookEvent.exists?(event_id: payload["event_id"])

    WebhookEvent.create!(
      event_id: payload["event_id"],
      event_type: payload["event_type"],
      occurred_at: payload["occurred_at"],
      payload: payload
    )

    charge = Charge.find_or_create_by!(
      external_id: payload["charge_external_id"]
    ) do |c|
      c.amount_cents = payload["amount_cents"]
      c.currency = payload["currency"]
    end

    dispute = Dispute.find_or_initialize_by(
      external_id: payload["dispute_external_id"]
    )

    if dispute.persisted?
      return if dispute.updated_at > payload["occurred_at"]
    end

    dispute.assign_attributes(
      charge: charge,
      amount_cents: payload["amount_cents"],
      currency: payload["currency"],
      opened_at: payload["occurred_at"],
      external_payload: payload
    )

    dispute.save!

    handle_status_transition(dispute, payload["status"])
  end

  private

  def handle_status_transition(dispute, status)
    case status
    when "open"
      dispute.reopen! if dispute.may_reopen?
    when "needs_evidence"
      dispute.request_evidence! if dispute.may_request_evidence?
    when "awaiting_decision"
      dispute.submit_evidence! if dispute.may_submit_evidence?
    when "won"
      dispute.decide_won! if dispute.may_decide_won?
    when "lost"
      dispute.decide_lost! if dispute.may_decide_lost?
    end
  end
end
