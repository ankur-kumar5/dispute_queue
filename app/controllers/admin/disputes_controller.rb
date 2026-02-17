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
end
