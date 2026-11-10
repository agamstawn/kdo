# Data demonstrasi fiktif untuk menampilkan alur kerja KDO secara utuh.
# Jangan gunakan NIP atau nomor polisi ini sebagai data produksi.

admin = User.find_or_initialize_by(email_address: "admin@kdo.test")
if admin.new_record?
  admin.password = "KDO-Demo-2026!"
  admin.password_confirmation = "KDO-Demo-2026!"
  admin.save!
end

perangkat_daerah = ["Dinas Pendidikan", "Dinas Kesehatan", "Dinas PUPR"].index_with do |nama|
  PerangkatDaerah.find_or_create_by!(nama: nama)
end

pegawai = [
  { nama: "Rina Wulandari", nip: "198403152010012001", jabatan: "Analis Sarana Prasarana", golongan: "III/c", dinas: "Dinas Pendidikan" },
  { nama: "Dimas Pratama", nip: "198607212011011002", jabatan: "Pengelola Barang Milik Daerah", golongan: "III/b", dinas: "Dinas Pendidikan" },
  { nama: "Lestari Utami", nip: "198810122012012005", jabatan: "Pranata Komputer", golongan: "III/b", dinas: "Dinas Pendidikan" },
  { nama: "Sari Handayani", nip: "198501102009012003", jabatan: "Perencana Kesehatan", golongan: "III/c", dinas: "Dinas Kesehatan" },
  { nama: "Budi Santoso", nip: "198707142011011006", jabatan: "Pengelola Program Kesehatan", golongan: "III/b", dinas: "Dinas Kesehatan" },
  { nama: "Nabila Putri", nip: "199003182013022007", jabatan: "Analis Laboratorium Kesehatan", golongan: "III/a", dinas: "Dinas Kesehatan" },
  { nama: "Arif Nugroho", nip: "198209182008011004", jabatan: "Teknisi Jalan dan Jembatan", golongan: "III/d", dinas: "Dinas PUPR" },
  { nama: "Yoga Prasetyo", nip: "198508092010011008", jabatan: "Pengawas Jalan", golongan: "III/c", dinas: "Dinas PUPR" },
  { nama: "Maya Safitri", nip: "199104252014022009", jabatan: "Perencana Infrastruktur", golongan: "III/a", dinas: "Dinas PUPR" }
].each_with_object({}) do |attributes, records|
  record = Pegawai.find_or_initialize_by(nip: attributes[:nip]).tap do |pegawai_record|
    pegawai_record.assign_attributes(attributes.except(:dinas).merge(perangkat_daerah: perangkat_daerah.fetch(attributes[:dinas])))
    pegawai_record.save!
  end
  records[attributes[:nip]] = record
end

kendaraan = [
  { nomor_polisi: "B 1234 KDO", merek: "Toyota", model: "Innova Reborn", tahun_produksi: 2022, warna: "Hitam", status: :baik, dinas: "Dinas Pendidikan", nip: "198403152010012001" },
  { nomor_polisi: "B 1540 KDO", merek: "Honda", model: "BR-V", tahun_produksi: 2023, warna: "Abu-abu", status: :baik, dinas: "Dinas Pendidikan", nip: "198607212011011002" },
  { nomor_polisi: "B 1678 KDO", merek: "Toyota", model: "HiAce", tahun_produksi: 2021, warna: "Silver", status: :baik, dinas: "Dinas Pendidikan", nip: "198810122012012005" },
  { nomor_polisi: "B 2345 KDO", merek: "Mitsubishi", model: "L300", tahun_produksi: 2019, warna: "Putih", status: :rusak_ringan, dinas: "Dinas Kesehatan", nip: "198501102009012003" },
  { nomor_polisi: "B 2121 KDO", merek: "Suzuki", model: "Ertiga", tahun_produksi: 2020, warna: "Hitam", status: :baik, dinas: "Dinas Kesehatan", nip: "198707142011011006" },
  { nomor_polisi: "B 2789 KDO", merek: "Toyota", model: "Fortuner", tahun_produksi: 2021, warna: "Putih", status: :rusak_ringan, dinas: "Dinas Kesehatan", nip: "198501102009012003" },
  { nomor_polisi: "B 2965 KDO", merek: "Daihatsu", model: "Gran Max", tahun_produksi: 2018, warna: "Silver", status: :baik, dinas: "Dinas Kesehatan", nip: "199003182013022007" },
  { nomor_polisi: "B 3456 KDO", merek: "Isuzu", model: "D-Max", tahun_produksi: 2017, warna: "Abu-abu", status: :rusak_berat, dinas: "Dinas PUPR", nip: "198209182008011004" },
  { nomor_polisi: "B 3110 KDO", merek: "Mitsubishi", model: "Triton", tahun_produksi: 2020, warna: "Merah", status: :baik, dinas: "Dinas PUPR", nip: "198508092010011008" },
  { nomor_polisi: "B 3871 KDO", merek: "Toyota", model: "Hilux", tahun_produksi: 2018, warna: "Hitam", status: :rusak_ringan, dinas: "Dinas PUPR", nip: "199104252014022009" },
  { nomor_polisi: "B 3992 KDO", merek: "Isuzu", model: "ELF", tahun_produksi: 2016, warna: "Putih", status: :rusak_berat, dinas: "Dinas PUPR", nip: "198209182008011004" }
].each_with_object({}) do |attributes, records|
  record = KendaraanDinas.find_or_initialize_by(nomor_polisi: attributes[:nomor_polisi]).tap do |kendaraan_record|
    kendaraan_record.assign_attributes(attributes.except(:dinas, :nip).merge(perangkat_daerah: perangkat_daerah.fetch(attributes[:dinas]), penanggung_jawab: pegawai.fetch(attributes[:nip])))
    kendaraan_record.save!
  end
  records[attributes[:nomor_polisi]] = record
end

[
  { nomor_polisi: "B 1540 KDO", tanggal: Date.new(2026, 5, 12), jenis: "Servis berkala", keterangan: "Penggantian oli, filter udara, dan pemeriksaan ban.", biaya: 980_000 },
  { nomor_polisi: "B 1678 KDO", tanggal: Date.new(2026, 6, 8), jenis: "Perawatan AC", keterangan: "Pembersihan evaporator dan penggantian filter kabin.", biaya: 650_000 },
  { nomor_polisi: "B 2965 KDO", tanggal: Date.new(2026, 6, 21), jenis: "Ganti oli", keterangan: "Penggantian oli mesin dan pemeriksaan sistem pendingin.", biaya: 720_000 },
  { nomor_polisi: "B 2121 KDO", tanggal: Date.new(2026, 7, 16), jenis: "Servis rem", keterangan: "Penggantian kampas rem depan dan penyetelan rem belakang.", biaya: 1_100_000 },
  { nomor_polisi: "B 3110 KDO", tanggal: Date.new(2026, 8, 5), jenis: "Pemeriksaan suspensi", keterangan: "Pemeriksaan kaki-kaki kendaraan untuk perjalanan lapangan.", biaya: 875_000 },
  { nomor_polisi: "B 3871 KDO", tanggal: Date.new(2026, 8, 27), jenis: "Perbaikan transmisi", keterangan: "Diagnosa perpindahan gigi yang tidak responsif.", biaya: 2_450_000 },
  { nomor_polisi: "B 1234 KDO", tanggal: Date.new(2026, 9, 15), jenis: "Servis berkala", keterangan: "Penggantian oli mesin dan pemeriksaan rem.", biaya: 1_250_000 },
  { nomor_polisi: "B 2789 KDO", tanggal: Date.new(2026, 9, 29), jenis: "Penggantian ban", keterangan: "Penggantian dua ban depan yang sudah aus.", biaya: 2_100_000 },
  { nomor_polisi: "B 2345 KDO", tanggal: Date.new(2026, 10, 3), jenis: "Perbaikan AC", keterangan: "Pemeriksaan kompresor dan pengisian refrigeran.", biaya: 850_000 },
  { nomor_polisi: "B 3456 KDO", tanggal: Date.new(2026, 10, 22), jenis: "Pemeriksaan mesin", keterangan: "Diagnosa kerusakan sistem injeksi sebelum perbaikan lanjutan.", biaya: 450_000 },
  { nomor_polisi: "B 3992 KDO", tanggal: Date.new(2026, 10, 25), jenis: "Perbaikan sistem bahan bakar", keterangan: "Perbaikan pompa bahan bakar dan pembersihan injektor.", biaya: 3_750_000 },
  { nomor_polisi: "B 2345 KDO", tanggal: Date.new(2026, 11, 4), jenis: "Perbaikan bodi", keterangan: "Perbaikan panel pintu dan pengecatan ringan.", biaya: 1_600_000 }
].each do |attributes|
  RiwayatPerawatan.find_or_create_by!(kendaraan_dinas: kendaraan.fetch(attributes[:nomor_polisi]), tanggal: attributes[:tanggal], jenis: attributes[:jenis]) do |record|
    record.keterangan = attributes[:keterangan]
    record.biaya = attributes[:biaya]
  end
end
