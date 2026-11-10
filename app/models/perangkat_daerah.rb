class PerangkatDaerah < ApplicationRecord
  has_many :pegawais, dependent: :restrict_with_error
  has_many :kendaraan_dinas, class_name: "KendaraanDinas", dependent: :restrict_with_error

  validates :nama, presence: true, uniqueness: { case_sensitive: false }

  scope :search, ->(query) { query.present? ? where("nama LIKE ?", "%#{sanitize_sql_like(query)}%") : all }
end
