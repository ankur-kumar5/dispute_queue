class Webhooks::DisputesController < ApplicationController
  skip_before_action :require_authentication
  skip_before_action :verify_authenticity_token

  def create
    WebhookProcessorJob.perform_later(webhook_params.to_h)
    head :accepted
  end

  private

  def webhook_params
    params.permit(:event_id, :event_type, :occurred_at,
      :charge_external_id, :dispute_external_id,
      :amount_cents, :currency, :status)
  end
end
