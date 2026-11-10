class KendaraanDinas < ApplicationRecord
  belongs_to :perangkat_daerah
  belongs_to :penanggung_jawab, class_name: "Pegawai"

  enum :status, { baik: 0, perlu_perawatan: 1, rusak: 2, tidak_aktif: 3 }, validate: true

  validates :nomor_polisi, :merek, :model, :warna, presence: true
  validates :nomor_polisi, uniqueness: { case_sensitive: false }
  validates :tahun_produksi, numericality: { only_integer: true, greater_than_or_equal_to: 1900, less_than_or_equal_to: ->(_record) { Date.current.year + 1 } }
  validate :pegawai_satu_perangkat_daerah

  private

  def pegawai_satu_perangkat_daerah
    return if perangkat_daerah_id.blank? || penanggung_jawab_id.blank? || penanggung_jawab&.perangkat_daerah_id == perangkat_daerah_id

    errors.add(:penanggung_jawab, "harus berasal dari perangkat daerah yang sama")
  end
end
