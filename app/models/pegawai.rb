class Pegawai < ApplicationRecord
  belongs_to :perangkat_daerah
  has_many :kendaraan_tanggung_jawab, class_name: "KendaraanDinas", foreign_key: :penanggung_jawab_id, dependent: :restrict_with_error

  validates :nama, :nip, :jabatan, :golongan, presence: true
  validates :nip, uniqueness: true, format: { with: /\A\d{18}\z/, message: "harus terdiri dari 18 digit" }

  scope :search, ->(query) { query.present? ? where("nama LIKE :query OR nip LIKE :query OR jabatan LIKE :query", query: "%#{sanitize_sql_like(query)}%") : all }
  scope :for_perangkat_daerah, ->(id) { id.present? ? where(perangkat_daerah_id: id) : all }
end
