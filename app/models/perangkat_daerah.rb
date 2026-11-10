class PerangkatDaerah < ApplicationRecord
  has_many :pegawais, dependent: :restrict_with_error
  has_many :kendaraan_dinas, class_name: "KendaraanDinas", dependent: :restrict_with_error

  validates :nama, presence: true, uniqueness: { case_sensitive: false }
end
