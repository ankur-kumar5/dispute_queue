class EvidencePolicy < ApplicationPolicy

    def new?
        admin? || reviewer?
    end
    def create?
        admin? || reviewer?
    end

    def destroy?
        admin?
    end
end
