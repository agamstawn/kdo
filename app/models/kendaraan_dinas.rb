class KendaraanDinas < ApplicationRecord
  belongs_to :perangkat_daerah
  belongs_to :penanggung_jawab, class_name: "Pegawai"
  has_many :riwayat_perawatans, class_name: "RiwayatPerawatan", dependent: :restrict_with_error

  enum :status, { baik: 0, rusak_ringan: 1, rusak_berat: 2 }, validate: true

  validates :nomor_polisi, :merek, :model, :warna, presence: true
  validates :nomor_polisi, uniqueness: { case_sensitive: false }
  validates :tahun_produksi, numericality: { only_integer: true, greater_than_or_equal_to: 1900, less_than_or_equal_to: ->(_record) { Date.current.year + 1 } }
  validate :pegawai_satu_perangkat_daerah

  scope :search, ->(query) { query.present? ? where("nomor_polisi LIKE :query OR merek LIKE :query OR model LIKE :query", query: "%#{sanitize_sql_like(query)}%") : all }
  scope :by_status, ->(status) { statuses.key?(status) ? where(status: status) : all }
  scope :for_perangkat_daerah, ->(id) { id.present? ? where(perangkat_daerah_id: id) : all }

  private

  def pegawai_satu_perangkat_daerah
    return if perangkat_daerah_id.blank? || penanggung_jawab_id.blank? || penanggung_jawab&.perangkat_daerah_id == perangkat_daerah_id

    errors.add(:penanggung_jawab, "harus berasal dari perangkat daerah yang sama")
  end
end
