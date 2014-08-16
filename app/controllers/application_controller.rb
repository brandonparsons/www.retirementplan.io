class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  protected

  def xhr_only
    raise ActiveRecord::RecordNotFound unless request.xhr?
  end

  def missing_parameters
    render json: {success: false, message: "422 - Missing parameters"}, status: 422
  end

  def invalid_parameters(message="422 - Invalid parameters")
    render json: {success: false, message: message}, status: 422
  end

end
