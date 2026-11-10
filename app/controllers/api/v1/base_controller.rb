class Api::V1::BaseController < ApplicationController
  skip_forgery_protection
  skip_before_action :require_authentication
  before_action :require_api_key_in_production

  rescue_from ActiveRecord::RecordNotFound do
    render json: { error: "Data tidak ditemukan" }, status: :not_found
  end

  private

  def require_api_key_in_production
    return unless Rails.env.production?

    expected_key = ENV["KDO_API_KEY"]
    provided_key = request.headers["X-API-Key"]

    if expected_key.blank?
      render json: { error: "API belum dikonfigurasi" }, status: :service_unavailable
    elsif provided_key.blank? || !ActiveSupport::SecurityUtils.secure_compare(provided_key, expected_key)
      render json: { error: "Tidak terautentikasi" }, status: :unauthorized
    end
  end

  def render_validation_errors(record)
    render json: { errors: record.errors.to_hash(true) }, status: :unprocessable_entity
  end
end
