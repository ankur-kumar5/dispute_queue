class Admin::BaseController < ApplicationController
   before_action :require_authentication
   layout "admin"

   private

   def log_case_action(action_name, evidence)
      CaseAction.create!(
        dispute: @dispute,
        user: Current.user,
        action: action_name,
        note: evidence ? evidence.metadata["note"] : nil,
        details: evidence&.metadata
      )
   end
end
