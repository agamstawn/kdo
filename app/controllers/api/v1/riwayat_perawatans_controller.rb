class Api::V1::RiwayatPerawatansController < Api::V1::BaseController
  before_action :set_record, only: %i[show update destroy]

  def index
    scope = RiwayatPerawatan.includes(:kendaraan_dinas).search(params[:q]).for_kendaraan(params[:kendaraan_dinas_id]).order(tanggal: :desc)
    render_collection(scope, include: :kendaraan_dinas)
  end

  def show
    render json: @record, include: :kendaraan_dinas
  end

  def create
    record = RiwayatPerawatan.new(record_params)
    record.save ? render(json: record, status: :created) : render_validation_errors(record)
  end

  def update
    @record.update(record_params) ? render(json: @record) : render_validation_errors(@record)
  end

  def destroy
    @record.destroy
    head :no_content
  end

  private

  def set_record
    @record = RiwayatPerawatan.find(params[:id])
  end

  def record_params
    params.require(:riwayat_perawatan).permit(:kendaraan_dinas_id, :tanggal, :jenis, :keterangan, :biaya)
  end
end
