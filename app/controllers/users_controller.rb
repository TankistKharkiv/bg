class UsersController < ApplicationController
  prepend_before_action :set_user, only: [:show, :update]
  def index
    render json: User.decorate.map(&:index_json)
  end

  def show
    render json: @user.decorate.show_json
  end

  def update
    service = User::UpdateService.new(@user, params)
    if service.call
      render json: {success: true, user: service.user.decorate.show_json}
    else
      render json: {success: false, errors: service.errors}
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
  def record
    @user
  end
end
