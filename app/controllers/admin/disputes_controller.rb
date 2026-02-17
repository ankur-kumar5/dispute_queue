# Admin DisputesController
class Admin::DisputesController < Admin::BaseController
  def index
    @disputes = policy_scope(Dispute).order(created_at: :desc)
  end

  def show
    @dispute = Dispute.find(params[:id])
    authorize @dispute
  end

  def request_evidence
    @dispute = Dispute.find(params[:id])
    authorize @dispute

    @dispute.request_evidence!
    redirect_to @dispute
  end

  def decide_won
    @dispute = Dispute.find(params[:id])
    authorize @dispute
    @dispute.decide_won!
    log_case_action("dispute_decided_won", nil)
    redirect_to admin_dispute_path(@dispute),
                notice: "Decision won recorded."
  end

  def decide_lost
    @dispute = Dispute.find(params[:id])
    authorize @dispute
    @dispute.decide_lost!
    log_case_action("dispute_decided_lost", nil)
    redirect_to admin_dispute_path(@dispute),
                notice: "Decision lost recorded."
  end

end
