class CompaniesController < ApplicationController
  prepend_before_action :set_company, only: [:show, :update]

  def index
    render json: Company.decorate.map(&:index_json)
  end

  def show
    render json: @company.decorate.show_json
  end

  def update
    service = Company::UpdateService.new(@company, params)
    if service.call
      render json: {success: true}
    else
      render json: {success: false, errors: service.errors}
    end

  end

  private

  def set_company
    @company = Company.find(params[:id])
  end
  def record
    @company
  end
end
