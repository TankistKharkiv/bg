class BaseUpdateService
  protected
  def params_permitter(params)
    params.permit!.to_h.deep_symbolize_keys
  end
end