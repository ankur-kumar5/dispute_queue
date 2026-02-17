class DisputePolicy < ApplicationPolicy

  # ---- Viewing ----

  def index?
    user.present?
  end

  def show?
    user.present?
  end

  # ---- Transitions ----

  def request_evidence?
    admin? || reviewer?
  end

  def submit_evidence?
    admin? || reviewer?
  end

  def decide_won?
    admin? || reviewer?
  end

  def decide_lost?
    admin? || reviewer?
  end

  def reopen?
    admin? || reviewer?
  end

  # ---- Destructive ----

  def destroy?
    admin?
  end

  # ---- Scope ----

  class Scope < Scope
    def resolve
      if user.admin? || user.reviewer? || user.read_only?
        scope.all
      else
        scope.none
      end
    end
  end
end
