class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include Pundit
  respond_to :json
  before_action :authenticate_user!
  before_action :check_policy, only: :update
  private

  def check_policy
    authorize(record, :update?)
  rescue Pundit::NotAuthorizedError
    render json: {error: 'You have no rights for update'}
  end


end
