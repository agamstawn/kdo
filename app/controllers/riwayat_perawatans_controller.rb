class RiwayatPerawatansController < ApplicationController
  before_action :set_riwayat_perawatan, only: %i[show edit update destroy]

  def index
    scope = RiwayatPerawatan.includes(kendaraan_dinas: :perangkat_daerah).search(params[:q]).for_kendaraan(params[:kendaraan_dinas_id]).order(tanggal: :desc)
    @pagination = paginate(scope)
    @riwayat_perawatans = @pagination.records
  end

  def show; end

  def new
    @riwayat_perawatan = RiwayatPerawatan.new(tanggal: Date.current, kendaraan_dinas_id: params[:kendaraan_dinas_id])
  end

  def edit; end

  def create
    @riwayat_perawatan = RiwayatPerawatan.new(riwayat_perawatan_params)
    if @riwayat_perawatan.save
      redirect_to @riwayat_perawatan, notice: "Riwayat perawatan berhasil ditambahkan."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @riwayat_perawatan.update(riwayat_perawatan_params)
      redirect_to @riwayat_perawatan, notice: "Riwayat perawatan berhasil diperbarui."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @riwayat_perawatan.destroy
    redirect_to riwayat_perawatans_path, notice: "Riwayat perawatan berhasil dihapus."
  end

  private

  def set_riwayat_perawatan
    @riwayat_perawatan = RiwayatPerawatan.find(params[:id])
  end

  def riwayat_perawatan_params
    params.require(:riwayat_perawatan).permit(:kendaraan_dinas_id, :tanggal, :jenis, :keterangan, :biaya)
  end
end
