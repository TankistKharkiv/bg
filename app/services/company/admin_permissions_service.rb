class Company::AdminPermissionsService
  attr_accessor :admin, :category

  def new(admin, category)
    self.admin = admin
    self.category = category
  end

  def has_rights?
    adm_cat =admin.category
    adm_cat == category || (adm_cat.lft<category.lft && adm_cat>category.rgt)
  end
end