class CompanyPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def update?
    user.admin? && Company::AdminPermissionsService.new(user, record).has_rights?
  end
end
