class RiwayatPerawatan < ApplicationRecord
  belongs_to :kendaraan_dinas, class_name: "KendaraanDinas"

  validates :tanggal, :jenis, :keterangan, presence: true
  validates :biaya, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
end
