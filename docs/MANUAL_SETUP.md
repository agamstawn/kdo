# Manual Setup dan Demonstrasi KDO

Dokumen ini memandu instalasi lokal, penggunaan akun demonstrasi, alur uji fitur, dan verifikasi aplikasi KDO.

## 1. Prasyarat

- Ruby `3.2.0`
- Bundler
- SQLite 3

Jalankan seluruh perintah dari akar proyek.

```bash
ruby -v
bundle -v
sqlite3 --version
```

Versi Ruby harus diawali `3.2.0`.

## 2. Instalasi dan inisialisasi database

```bash
bundle install
bin/rails db:prepare
bin/rails db:seed
bin/rails server
```

Buka `http://localhost:3000`. Pengunjung akan diarahkan ke halaman masuk bila belum mempunyai sesi.

`db:prepare` membuat/memigrasikan database bila diperlukan. `db:seed` aman dijalankan berulang untuk data contoh yang sama. Jangan menjalankan `bin/rails db:reset` kecuali Anda memang mengizinkan penghapusan seluruh data development lokal.

## 3. Akun demonstrasi

| Email | Kata sandi |
| --- | --- |
| `admin@kdo.test` | `KDO-Demo-2026!` |

Kredensial ini merupakan data demo lokal yang dibuat oleh `db:seed`; bukan akun production. Sebelum deployment, buat pengguna baru dengan kata sandi kuat dan kelola rahasia di secret manager/environment deployment. Jangan menyimpan kredensial production pada repository, screenshot, atau prompt AI.

## 4. Data yang disediakan seed

Seed memasukkan data fiktif berikut untuk demonstrasi yang lebih variatif:

| Data | Jumlah | Kegunaan |
| --- | ---: | --- |
| Perangkat daerah | 3 | Dinas Pendidikan, Dinas Kesehatan, Dinas PUPR |
| Pegawai | 9 | Penanggung jawab kendaraan |
| Kendaraan | 11 | Status baik, rusak ringan, dan rusak berat |
| Riwayat perawatan | 12 | Tren biaya dari Mei–November 2026 |
| Pengguna | 1 | Akun masuk demonstrasi |

Data tersebut tidak boleh diperlakukan sebagai data operasional nyata.

## 5. Alur demonstrasi aplikasi

1. Masuk melalui `/sesi/new`.
2. Buka **Dasbor** dan periksa total armada, kartu kondisi, total biaya, komposisi kondisi, grafik biaya, serta daftar prioritas tindak lanjut.
3. Buka **Perangkat Daerah**, tambah atau ubah unit kerja, lalu buka **Detail** untuk melihat pegawai serta kendaraan milik unit tersebut.
4. Buka **Pegawai**, masukkan nama, NIP 18 digit, jabatan, golongan, dan perangkat daerah.
5. Buka **Kendaraan**, masukkan identitas kendaraan, pilih status, perangkat daerah, dan pegawai penanggung jawab yang berada pada unit sama.
6. Buka **Perawatan**, catat tanggal, jenis pekerjaan, uraian, dan biaya. Setelah disimpan, biaya tersebut ikut dihitung pada detail kendaraan dan dasbor.
7. Pada halaman daftar, coba pencarian/filter dan pindah halaman menggunakan pagination.
8. Pada setiap halaman detail, gunakan tombol **Kembali ke ...** untuk kembali ke daftar entitas yang sedang dibuka.
9. Coba menghapus perangkat daerah, pegawai, atau kendaraan yang masih punya relasi aktif. Aplikasi harus menolak tindakan tersebut dan menampilkan kesalahan yang dapat dipahami.
10. Keluar melalui tombol **Keluar** di navigasi.

## 6. Aturan dan validasi yang perlu diuji

| Aturan | Hasil yang diharapkan |
| --- | --- |
| NIP tidak terdiri dari 18 digit | Form/API menolak dengan kesalahan validasi |
| Nomor polisi atau nama perangkat daerah duplikat | Form/API menolak karena harus unik |
| Status selain `baik`, `rusak_ringan`, `rusak_berat` | Form/API menolak nilai tidak valid |
| Penanggung jawab dari perangkat daerah lain | Form/API menolak relasi tidak sesuai |
| Biaya perawatan negatif | Form/API menolak nilai negatif |
| Hapus data yang masih direferensikan | Aplikasi menolak untuk menjaga integritas |

## 7. Verifikasi otomatis

```bash
bin/rails test
bin/rails routes
bin/rails db:migrate:status
```

Pengujian meliputi aturan relasi dan validasi model, autentikasi sesi, aksi detail halaman web, serta CRUD REST API dan respons kesalahan.

## 8. Uji REST API dari terminal kedua

Biarkan `bin/rails server` berjalan pada terminal pertama. Buka terminal kedua untuk menguji endpoint API dengan `curl`.

```bash
export API_BASE='http://localhost:3000/api/v1'
curl -sS "$API_BASE/kendaraan?page=1&per_page=10"
```

Seluruh perintah `GET`, `POST`, `PATCH`, dan `DELETE` untuk keempat resource, termasuk filter dan pagination, tersedia di [API.md](API.md). Di development/test API tidak meminta sesi browser. Pada production, tambahkan header `X-API-Key` pada setiap request dan simpan nilainya di secret manager.

## 9. Dump SQLite demonstrasi

Artefak dump tersedia pada `db/dumps/kdo_sample.sql`. Untuk memeriksa dump tanpa menimpa database aplikasi, impor ke file sementara:

```bash
sqlite3 /tmp/kdo_sample.sqlite3 < db/dumps/kdo_sample.sql
sqlite3 /tmp/kdo_sample.sqlite3 '.tables'
```

Gunakan `db:prepare` dan `db:seed` sebagai cara utama menyiapkan database aplikasi saat ini. Dump disediakan sebagai artefak RDBMS demonstrasi; seluruh data di dalamnya harus diperlakukan sebagai contoh fiktif.

## 10. Konfigurasi API production

Semua endpoint `/api/v1` di production memerlukan `X-API-Key` yang dibandingkan dengan environment variable `KDO_API_KEY`. Aplikasi mengembalikan `503` bila variabel tersebut belum dikonfigurasi dan `401` bila kunci salah.

Tetapkan nilai melalui secret manager/deployment environment. Jangan memasukkan nilai kunci production dalam Git, dokumentasi, file seed, atau terminal yang direkam.

## 11. Bukti tampilan dan troubleshooting

Lihat [SCREENSHOTS.md](SCREENSHOTS.md) untuk bukti halaman masuk dan dasbor.

| Gejala | Pemeriksaan awal |
| --- | --- |
| Server tidak dapat dijalankan | Pastikan `bundle install` berhasil dan Ruby yang dipakai adalah 3.2.0 |
| Tabel belum tersedia | Jalankan `bin/rails db:prepare` |
| Tidak dapat masuk | Jalankan `bin/rails db:seed`, lalu gunakan akun demo yang tercantum di atas |
| Dasbor kosong | Jalankan kembali `bin/rails db:seed` dan muat ulang halaman |
| API production memberi `401` | Pastikan header `X-API-Key` cocok dengan secret `KDO_API_KEY` deployment |

