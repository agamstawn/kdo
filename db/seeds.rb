# Data demonstrasi fiktif untuk menampilkan alur kerja KDO secara utuh.
# Jangan gunakan NIP atau nomor polisi ini sebagai data produksi.

perangkat_daerah = ["Dinas Pendidikan", "Dinas Kesehatan", "Dinas PUPR"].index_with do |nama|
  PerangkatDaerah.find_or_create_by!(nama: nama)
end

pegawai = [
  { nama: "Rina Wulandari", nip: "198403152010012001", jabatan: "Analis Sarana Prasarana", golongan: "III/c", dinas: "Dinas Pendidikan" },
  { nama: "Dimas Pratama", nip: "198607212011011002", jabatan: "Pengelola Barang Milik Daerah", golongan: "III/b", dinas: "Dinas Pendidikan" },
  { nama: "Sari Handayani", nip: "198501102009012003", jabatan: "Perencana Kesehatan", golongan: "III/c", dinas: "Dinas Kesehatan" },
  { nama: "Arif Nugroho", nip: "198209182008011004", jabatan: "Teknisi Jalan dan Jembatan", golongan: "III/d", dinas: "Dinas PUPR" }
].each_with_object({}) do |attributes, records|
  record = Pegawai.find_or_initialize_by(nip: attributes[:nip]).tap do |pegawai_record|
    pegawai_record.assign_attributes(attributes.except(:dinas).merge(perangkat_daerah: perangkat_daerah.fetch(attributes[:dinas])))
    pegawai_record.save!
  end
  records[attributes[:nip]] = record
end

kendaraan = [
  { nomor_polisi: "B 1234 KDO", merek: "Toyota", model: "Innova Reborn", tahun_produksi: 2022, warna: "Hitam", status: :baik, dinas: "Dinas Pendidikan", nip: "198403152010012001" },
  { nomor_polisi: "B 2345 KDO", merek: "Mitsubishi", model: "L300", tahun_produksi: 2019, warna: "Putih", status: :rusak_ringan, dinas: "Dinas Kesehatan", nip: "198501102009012003" },
  { nomor_polisi: "B 3456 KDO", merek: "Isuzu", model: "D-Max", tahun_produksi: 2017, warna: "Abu-abu", status: :rusak_berat, dinas: "Dinas PUPR", nip: "198209182008011004" }
].each_with_object({}) do |attributes, records|
  record = KendaraanDinas.find_or_initialize_by(nomor_polisi: attributes[:nomor_polisi]).tap do |kendaraan_record|
    kendaraan_record.assign_attributes(attributes.except(:dinas, :nip).merge(perangkat_daerah: perangkat_daerah.fetch(attributes[:dinas]), penanggung_jawab: pegawai.fetch(attributes[:nip])))
    kendaraan_record.save!
  end
  records[attributes[:nomor_polisi]] = record
end

[
  { nomor_polisi: "B 1234 KDO", tanggal: Date.new(2026, 9, 15), jenis: "Servis berkala", keterangan: "Penggantian oli mesin dan pemeriksaan rem.", biaya: 1_250_000 },
  { nomor_polisi: "B 2345 KDO", tanggal: Date.new(2026, 10, 3), jenis: "Perbaikan AC", keterangan: "Pemeriksaan kompresor dan pengisian refrigeran.", biaya: 850_000 },
  { nomor_polisi: "B 3456 KDO", tanggal: Date.new(2026, 10, 22), jenis: "Pemeriksaan mesin", keterangan: "Diagnosa kerusakan sistem injeksi sebelum perbaikan lanjutan.", biaya: 450_000 }
].each do |attributes|
  RiwayatPerawatan.find_or_create_by!(kendaraan_dinas: kendaraan.fetch(attributes[:nomor_polisi]), tanggal: attributes[:tanggal], jenis: attributes[:jenis]) do |record|
    record.keterangan = attributes[:keterangan]
    record.biaya = attributes[:biaya]
  end
end
