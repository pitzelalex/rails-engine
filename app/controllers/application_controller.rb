class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  def render_not_found_response(exception)
    render json: { errors: [
      {
        message: exception.message,
        code: 'not_found'
      }
    ] }, status: :not_found
  end
end
