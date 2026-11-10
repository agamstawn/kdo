# Manual Setup dan Demonstrasi KDO

## 1. Instalasi lokal

Pastikan Ruby 3.2.0 dan SQLite 3 tersedia, kemudian jalankan dari akar proyek:

```bash
bundle install
bin/rails db:prepare
bin/rails db:seed
bin/rails server
```

Buka `http://localhost:3000`. Seed bersifat idempoten dan memuat tiga perangkat daerah, sembilan pegawai fiktif, sebelas kendaraan, dan dua belas riwayat perawatan lintas bulan sehingga grafik dasbor terisi.

Gunakan akun demonstrasi berikut untuk masuk:

| Email | Kata sandi |
| --- | --- |
| `admin@kdo.test` | `KDO-Demo-2026!` |

Kredensial tersebut hanya untuk lingkungan lokal/demonstrasi. Sebelum production, buat akun baru dengan kata sandi yang kuat dan jangan menyimpan kredensial production dalam Git atau dokumentasi.

## 2. Alur demonstrasi

1. Buka **Dasbor** untuk melihat total aset dan ringkasan tiga kondisi kendaraan.
2. Buka **Perangkat Daerah**, lalu buat atau ubah unit kerja.
3. Buka **Pegawai** dan masukkan PNS dengan NIP 18 digit.
4. Buka **Kendaraan** dan tetapkan pegawai penanggung jawab dari perangkat daerah yang sama.
5. Buka **Perawatan** untuk mencatat pekerjaan, tanggal, uraian, dan biaya.
6. Periksa dasbor untuk melihat total biaya perawatan, tren biaya per bulan, dan kendaraan yang perlu ditindaklanjuti.
7. Coba hapus pegawai atau perangkat daerah yang masih dipakai; aplikasi menolak tindakan tersebut untuk menjaga integritas data.

## 3. Status kendaraan

Status yang valid hanya:

- `baik`
- `rusak_ringan`
- `rusak_berat`

Status lama `tidak_aktif`, jika ada pada database lama, dinormalisasi menjadi `rusak_berat` melalui migrasi `20261110050000`.

## 4. Pengujian

```bash
bin/rails test
bin/rails db:migrate:status
bin/rails routes
```

## 5. Dump database demonstrasi

Dump tanpa data personal berada pada `db/dumps/kdo_sample.sql`. Untuk memuatnya pada SQLite kosong:

```bash
sqlite3 /tmp/kdo_sample.sqlite3 < db/dumps/kdo_sample.sql
```

Gunakan `bin/rails db:seed` untuk aplikasi Rails; dump disediakan sebagai artefak penilaian dan contoh struktur RDBMS.

## 6. Konfigurasi production API

Di production, semua endpoint `/api/v1` memerlukan header `X-API-Key`. Tetapkan `KDO_API_KEY` melalui secret manager atau environment deployment Anda. Jangan menyimpan nilainya di Git, README, atau prompt AI.

Contoh lengkap `curl` untuk seluruh operasi CRUD, filter, dan pagination tersedia pada [API.md](API.md).
