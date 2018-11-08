class Company::AdminPermissionsService
  attr_accessor :admin, :company

  def initialize(admin, company)
    self.admin = admin
    self.company = company
  end

  def has_rights?
    company.is_or_is_descendant_of? admin.company
    # adm_com =admin.company
    # adm_com == company || (adm_com.lft<company.lft && adm_com.rgt>company.rgt)
  end
end