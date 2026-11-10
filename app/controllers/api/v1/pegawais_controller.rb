class Api::V1::PegawaisController < Api::V1::BaseController
  before_action :set_record, only: %i[show update destroy]

  def index
    scope = Pegawai.includes(:perangkat_daerah).search(params[:q]).for_perangkat_daerah(params[:perangkat_daerah_id]).order(:nama)
    render_collection(scope, include: :perangkat_daerah)
  end

  def show
    render json: @record, include: :perangkat_daerah
  end

  def create
    record = Pegawai.new(record_params)
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
    @record = Pegawai.find(params[:id])
  end

  def record_params
    params.require(:pegawai).permit(:nama, :nip, :jabatan, :golongan, :perangkat_daerah_id)
  end
end
