# app/models/dispute.rb
class Dispute < ApplicationRecord
  include AASM

  belongs_to :charge
  has_many :case_actions
  has_many :evidences

  aasm column: :status do
    state :open, initial: true
    state :needs_evidence
    state :awaiting_decision
    state :won
    state :lost

    event :request_evidence do
      transitions from: :open, to: :needs_evidence
    end

    event :submit_evidence do
      transitions from: :needs_evidence, to: :awaiting_decision
    end

    event :decide_won do
      transitions from: [:awaiting_decision], to: :won
      after { self.closed_at = Time.current }
    end

    event :decide_lost do
      transitions from: [:awaiting_decision], to: :lost
      after { self.closed_at = Time.current }
    end

    event :reopen do
      transitions from: [:won, :lost], to: :open
    end
  end
end
