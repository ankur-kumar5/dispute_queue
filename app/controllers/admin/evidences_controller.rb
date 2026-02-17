class Admin::EvidencesController < Admin::BaseController
    before_action :set_dispute
    before_action :set_evidence, only: :destroy

    def new
        @evidence = @dispute.evidences.new
        authorize @evidence
        @case_actions = @dispute.case_actions.order(created_at: :desc)
    end

    def create
      ActiveRecord::Base.transaction do
        @evidence = @dispute.evidences.new(evidence_params)
        authorize @evidence

        if @evidence.save!
          @dispute.mark_awaiting_decision!
          log_case_action("evidence_added", @evidence)
          redirect_to [:admin, @dispute], notice: "Evidence added."
        else
          redirect_to [:admin, @dispute], alert: "Failed to add evidence."
        end  
      end
    end

    def destroy
      authorize @evidence

      @evidence.destroy
      log_case_action("evidence_removed", @evidence)

      redirect_to [:admin, @dispute], notice: "Evidence removed."
    end

    private

    def set_dispute
      @dispute = Dispute.find(params[:dispute_id])
    end

    def set_evidence
      @evidence = @dispute.evidences.find(params[:id])
    end

    def evidence_params
      {
        kind: params[:evidence][:kind],
        metadata: {
          note: params[:evidence][:note],
          file_path: params[:evidence][:file_path]
        }
      }
    end
end
