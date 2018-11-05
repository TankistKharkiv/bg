class UserDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end



  def show_json
    base_json.merge({
          company: company.decorate.base_json
        })
  end


  def base_json
    @base_json||={
        email: email,
        first_name: first_name,
        last_name: last_name,
    }
  end
  alias_method :index_json,:show_json
  alias_method :company_json, :base_json
end
