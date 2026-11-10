class KendaraanDinasController < ApplicationController
  before_action :set_kendaraan_dinas, only: %i[show edit update destroy]

  def index
    @kendaraan_dinas = KendaraanDinas.includes(:perangkat_daerah, :penanggung_jawab).order(:nomor_polisi)
  end

  def show; end

  def new
    @kendaraan_dinas = KendaraanDinas.new
  end

  def edit; end

  def create
    @kendaraan_dinas = KendaraanDinas.new(kendaraan_dinas_params)
    if @kendaraan_dinas.save
      redirect_to show_kendaraan_path(@kendaraan_dinas), notice: "Kendaraan berhasil ditambahkan."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @kendaraan_dinas.update(kendaraan_dinas_params)
      redirect_to show_kendaraan_path(@kendaraan_dinas), notice: "Kendaraan berhasil diperbarui."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @kendaraan_dinas.destroy
    redirect_to kendaraan_dinas_index_path, notice: "Kendaraan berhasil dihapus."
  end

  private

  def set_kendaraan_dinas
    @kendaraan_dinas = KendaraanDinas.find(params[:id])
  end

  def kendaraan_dinas_params
    params.require(:kendaraan_dinas).permit(:nomor_polisi, :merek, :model, :tahun_produksi, :warna, :status, :perangkat_daerah_id, :penanggung_jawab_id)
  end
end
