class PegawaisController < ApplicationController
  before_action :set_pegawai, only: %i[show edit update destroy]

  def index
    @pegawais = Pegawai.includes(:perangkat_daerah).order(:nama)
  end

  def show; end

  def new
    @pegawai = Pegawai.new
  end

  def edit; end

  def create
    @pegawai = Pegawai.new(pegawai_params)
    if @pegawai.save
      redirect_to @pegawai, notice: "Pegawai berhasil ditambahkan."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @pegawai.update(pegawai_params)
      redirect_to @pegawai, notice: "Pegawai berhasil diperbarui."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @pegawai.destroy
    if @pegawai.errors.any?
      redirect_to pegawais_path, alert: @pegawai.errors.full_messages.to_sentence
    else
      redirect_to pegawais_path, notice: "Pegawai berhasil dihapus."
    end
  end

  private

  def set_pegawai
    @pegawai = Pegawai.find(params[:id])
  end

  def pegawai_params
    params.require(:pegawai).permit(:nama, :nip, :jabatan, :golongan, :perangkat_daerah_id)
  end
end
