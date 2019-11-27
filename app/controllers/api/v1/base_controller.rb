class Api::V1::BaseController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found_response

  private

  def record_not_found_response(error)
    render json: { result: 'error', message: record_not_found_message(error) }, status: :not_found
  end

  def record_not_found_message(error)
    error.message
  end
end
