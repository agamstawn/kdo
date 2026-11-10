class Api::V1::BaseController < ApplicationController
  skip_forgery_protection

  rescue_from ActiveRecord::RecordNotFound do
    render json: { error: "Data tidak ditemukan" }, status: :not_found
  end

  private

  def render_validation_errors(record)
    render json: { errors: record.errors.to_hash(true) }, status: :unprocessable_entity
  end
end
