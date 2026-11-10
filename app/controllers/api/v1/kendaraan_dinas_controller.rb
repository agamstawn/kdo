class Api::V1::KendaraanDinasController < Api::V1::BaseController
  before_action :set_record, only: %i[show update destroy]

  def index
    scope = KendaraanDinas.includes(:perangkat_daerah, :penanggung_jawab).search(params[:q]).by_status(params[:status]).for_perangkat_daerah(params[:perangkat_daerah_id]).order(:nomor_polisi)
    render_collection(scope, include: %i[perangkat_daerah penanggung_jawab])
  end

  def show
    render json: @record, include: %i[perangkat_daerah penanggung_jawab]
  end

  def create
    record = KendaraanDinas.new(record_params)
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
    @record = KendaraanDinas.find(params[:id])
  end

  def record_params
    params.require(:kendaraan_dinas).permit(:nomor_polisi, :merek, :model, :tahun_produksi, :warna, :status, :perangkat_daerah_id, :penanggung_jawab_id)
  end
end
