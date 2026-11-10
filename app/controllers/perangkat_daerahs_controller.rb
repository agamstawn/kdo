class PerangkatDaerahsController < ApplicationController
  before_action :set_perangkat_daerah, only: %i[show edit update destroy]

  def index
    @perangkat_daerahs = PerangkatDaerah.order(:nama)
  end

  def show; end

  def new
    @perangkat_daerah = PerangkatDaerah.new
  end

  def edit; end

  def create
    @perangkat_daerah = PerangkatDaerah.new(perangkat_daerah_params)
    if @perangkat_daerah.save
      redirect_to @perangkat_daerah, notice: "Perangkat daerah berhasil ditambahkan."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @perangkat_daerah.update(perangkat_daerah_params)
      redirect_to @perangkat_daerah, notice: "Perangkat daerah berhasil diperbarui."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @perangkat_daerah.destroy
    if @perangkat_daerah.errors.any?
      redirect_to perangkat_daerahs_path, alert: @perangkat_daerah.errors.full_messages.to_sentence
    else
      redirect_to perangkat_daerahs_path, notice: "Perangkat daerah berhasil dihapus."
    end
  end

  private

  def set_perangkat_daerah
    @perangkat_daerah = PerangkatDaerah.find(params[:id])
  end

  def perangkat_daerah_params
    params.require(:perangkat_daerah).permit(:nama)
  end
end
