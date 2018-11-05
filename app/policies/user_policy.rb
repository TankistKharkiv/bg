class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end

  end
  def update?
    (user.id == record.id ||
        Company::AdminPermissionsService.new(user, record.company).has_rights?)
  end
end
