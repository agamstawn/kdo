-- KDO SQLite sample dump. All people and operational data below are fictional.
PRAGMA foreign_keys = OFF;
BEGIN TRANSACTION;

CREATE TABLE perangkat_daerahs (id INTEGER PRIMARY KEY, nama VARCHAR NOT NULL, created_at DATETIME NOT NULL, updated_at DATETIME NOT NULL);
CREATE UNIQUE INDEX index_perangkat_daerahs_on_nama ON perangkat_daerahs (nama);
INSERT INTO perangkat_daerahs VALUES (1, 'Dinas Pendidikan', '2026-11-10 00:00:00', '2026-11-10 00:00:00');
INSERT INTO perangkat_daerahs VALUES (2, 'Dinas Kesehatan', '2026-11-10 00:00:00', '2026-11-10 00:00:00');
INSERT INTO perangkat_daerahs VALUES (3, 'Dinas PUPR', '2026-11-10 00:00:00', '2026-11-10 00:00:00');

CREATE TABLE pegawais (id INTEGER PRIMARY KEY, nama VARCHAR NOT NULL, nip VARCHAR NOT NULL, jabatan VARCHAR NOT NULL, golongan VARCHAR NOT NULL, perangkat_daerah_id INTEGER NOT NULL, created_at DATETIME NOT NULL, updated_at DATETIME NOT NULL, FOREIGN KEY(perangkat_daerah_id) REFERENCES perangkat_daerahs(id));
CREATE UNIQUE INDEX index_pegawais_on_nip ON pegawais (nip);
INSERT INTO pegawais VALUES (1, 'Rina Wulandari', '198403152010012001', 'Analis Sarana Prasarana', 'III/c', 1, '2026-11-10 00:00:00', '2026-11-10 00:00:00');
INSERT INTO pegawais VALUES (2, 'Sari Handayani', '198501102009012003', 'Perencana Kesehatan', 'III/c', 2, '2026-11-10 00:00:00', '2026-11-10 00:00:00');
INSERT INTO pegawais VALUES (3, 'Arif Nugroho', '198209182008011004', 'Teknisi Jalan dan Jembatan', 'III/d', 3, '2026-11-10 00:00:00', '2026-11-10 00:00:00');

CREATE TABLE kendaraan_dinas (id INTEGER PRIMARY KEY, nomor_polisi VARCHAR NOT NULL, merek VARCHAR NOT NULL, model VARCHAR NOT NULL, tahun_produksi INTEGER NOT NULL, warna VARCHAR NOT NULL, status INTEGER NOT NULL DEFAULT 0, perangkat_daerah_id INTEGER NOT NULL, penanggung_jawab_id INTEGER NOT NULL, created_at DATETIME NOT NULL, updated_at DATETIME NOT NULL, FOREIGN KEY(perangkat_daerah_id) REFERENCES perangkat_daerahs(id), FOREIGN KEY(penanggung_jawab_id) REFERENCES pegawais(id));
CREATE UNIQUE INDEX index_kendaraan_dinas_on_nomor_polisi ON kendaraan_dinas (nomor_polisi);
INSERT INTO kendaraan_dinas VALUES (1, 'B 1234 KDO', 'Toyota', 'Innova Reborn', 2022, 'Hitam', 0, 1, 1, '2026-11-10 00:00:00', '2026-11-10 00:00:00');
INSERT INTO kendaraan_dinas VALUES (2, 'B 2345 KDO', 'Mitsubishi', 'L300', 2019, 'Putih', 1, 2, 2, '2026-11-10 00:00:00', '2026-11-10 00:00:00');
INSERT INTO kendaraan_dinas VALUES (3, 'B 3456 KDO', 'Isuzu', 'D-Max', 2017, 'Abu-abu', 2, 3, 3, '2026-11-10 00:00:00', '2026-11-10 00:00:00');

CREATE TABLE riwayat_perawatans (id INTEGER PRIMARY KEY, kendaraan_dinas_id INTEGER NOT NULL, tanggal DATE NOT NULL, jenis VARCHAR NOT NULL, keterangan TEXT NOT NULL, biaya DECIMAL(15,2), created_at DATETIME NOT NULL, updated_at DATETIME NOT NULL, FOREIGN KEY(kendaraan_dinas_id) REFERENCES kendaraan_dinas(id));
CREATE INDEX index_riwayat_perawatans_on_kendaraan_dinas_id ON riwayat_perawatans (kendaraan_dinas_id);
CREATE INDEX index_riwayat_perawatans_on_tanggal ON riwayat_perawatans (tanggal);
INSERT INTO riwayat_perawatans VALUES (1, 1, '2026-09-15', 'Servis berkala', 'Penggantian oli mesin dan pemeriksaan rem.', 1250000, '2026-11-10 00:00:00', '2026-11-10 00:00:00');
INSERT INTO riwayat_perawatans VALUES (2, 2, '2026-10-03', 'Perbaikan AC', 'Pemeriksaan kompresor dan pengisian refrigeran.', 850000, '2026-11-10 00:00:00', '2026-11-10 00:00:00');
INSERT INTO riwayat_perawatans VALUES (3, 3, '2026-10-22', 'Pemeriksaan mesin', 'Diagnosa kerusakan sistem injeksi sebelum perbaikan lanjutan.', 450000, '2026-11-10 00:00:00', '2026-11-10 00:00:00');
COMMIT;
PRAGMA foreign_keys = ON;
