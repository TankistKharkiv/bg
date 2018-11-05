class CompanyDecorator < Draper::Decorator
  delegate_all


  def index_json
      @index_json||=base_json.merge(
          children: children.decorate.map(&:index_json)
      )
  end

  def show_json
    @show_json||= base_json.merge(
       users: users.decorate.map(&:company_json)
    )
  end

  def base_json
    @base_json||={
        id: id,
        name: name,
    }
  end

end
