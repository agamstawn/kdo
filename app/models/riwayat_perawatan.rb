class RiwayatPerawatan < ApplicationRecord
  belongs_to :kendaraan_dinas, class_name: "KendaraanDinas"

  validates :tanggal, :jenis, :keterangan, presence: true
  validates :biaya, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  scope :search, ->(query) { query.present? ? where("jenis LIKE :query OR keterangan LIKE :query", query: "%#{sanitize_sql_like(query)}%") : all }
  scope :for_kendaraan, ->(id) { id.present? ? where(kendaraan_dinas_id: id) : all }
end
