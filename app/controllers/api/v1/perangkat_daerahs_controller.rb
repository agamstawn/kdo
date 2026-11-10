class Api::V1::PerangkatDaerahsController < Api::V1::BaseController
  before_action :set_record, only: %i[show update destroy]

  def index
    render_collection(PerangkatDaerah.search(params[:q]).order(:nama))
  end

  def show
    render json: @record
  end

  def create
    record = PerangkatDaerah.new(record_params)
    record.save ? render(json: record, status: :created) : render_validation_errors(record)
  end

  def update
    @record.update(record_params) ? render(json: @record) : render_validation_errors(@record)
  end

  def destroy
    @record.destroy
    @record.errors.any? ? render_validation_errors(@record) : head(:no_content)
  end

  private

  def set_record
    @record = PerangkatDaerah.find(params[:id])
  end

  def record_params
    params.require(:perangkat_daerah).permit(:nama)
  end
end
