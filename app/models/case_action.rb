class CaseAction < ApplicationRecord
  belongs_to :dispute
  belongs_to :user
end
