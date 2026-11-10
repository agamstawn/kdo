# KDO — Kendaraan Dinas Operasional

Aplikasi full-stack Ruby on Rails untuk pendataan kendaraan dinas, kondisi kendaraan, perangkat daerah pemilik, dan PNS yang bertanggung jawab atas penggunaannya.

## Fitur

- Dasbor ringkas jumlah kendaraan, pegawai, dan perangkat daerah.
- CRUD kendaraan dinas: nomor polisi, merek, tipe/model, tahun produksi, warna, dan status kondisi.
- CRUD PNS: nama, NIP, jabatan, golongan, dan perangkat daerah.
- CRUD perangkat daerah, termasuk data awal Dinas Pendidikan, Dinas Kesehatan, dan Dinas PUPR.
- Validasi NIP (18 digit), nomor polisi unik, dan keterkaitan penanggung jawab dengan perangkat daerah kendaraan.
- Autentikasi sesi pengguna untuk seluruh halaman web, disertai pembatasan percobaan masuk dasar.
- REST API versi 1 dengan API key sebagai perlindungan dasar pada production, serta halaman web responsif pada desktop, tablet, dan ponsel.
- Fitur bisnis tambahan: catat riwayat perawatan, total biaya per kendaraan, total biaya pada dasbor, dan tren biaya perawatan per bulan.

## Prasyarat

- Ruby `3.2.0`
- Bundler
- SQLite 3

## Menjalankan aplikasi

```bash
bundle install
bin/rails db:prepare
bin/rails db:seed
bin/rails server
```

Buka `http://localhost:3000` di peramban.

## Akun demonstrasi

Setelah menjalankan `bin/rails db:seed`, gunakan akun berikut untuk masuk:

| Email | Kata sandi |
| --- | --- |
| `admin@kdo.test` | `KDO-Demo-2026!` |

Kredensial ini hanya untuk demonstrasi lokal. Ganti atau buat akun baru sebelum deployment, dan jangan gunakan kata sandi produksi dalam dokumentasi atau Git.

## Pengujian dan pemeriksaan

```bash
bin/rails test
bin/rails routes
bin/rails db:reset db:seed
```

Seed demonstrasi bersifat idempoten dan menyediakan variasi data kendaraan, kondisi, serta biaya perawatan lintas enam bulan untuk memvisualisasikan dasbor. Seluruh data seed adalah fiktif dan bukan untuk penggunaan produksi.

`db:reset` menghapus database development lokal, jadi gunakan hanya saat memang ingin membuat data ulang.

## Model data

| Entitas | Atribut utama | Relasi |
| --- | --- | --- |
| Perangkat Daerah | nama | Memiliki banyak pegawai dan kendaraan |
| Pegawai | nama, NIP, jabatan, golongan | Milik satu perangkat daerah; dapat menjadi penanggung jawab kendaraan |
| Kendaraan Dinas | nomor polisi, merek, model, tahun produksi, warna, status | Milik satu perangkat daerah dan satu pegawai penanggung jawab |

Status kendaraan yang didukung: `baik`, `rusak_ringan`, dan `rusak_berat`.

## REST API

Semua endpoint mengirim dan menerima JSON di bawah `/api/v1`.

| Resource | Endpoint |
| --- | --- |
| Perangkat daerah | `GET/POST /api/v1/perangkat-daerah`, `GET/PATCH/DELETE /api/v1/perangkat-daerah/:id` |
| Pegawai | `GET/POST /api/v1/pegawai`, `GET/PATCH/DELETE /api/v1/pegawai/:id` |
| Kendaraan | `GET/POST /api/v1/kendaraan`, `GET/PATCH/DELETE /api/v1/kendaraan/:id` |
| Riwayat perawatan | `GET/POST /api/v1/perawatan`, `GET/PATCH/DELETE /api/v1/perawatan/:id` |

Contoh payload pembuatan kendaraan:

```json
{
  "kendaraan_dinas": {
    "nomor_polisi": "B 1234 KDO",
    "merek": "Toyota",
    "model": "Innova",
    "tahun_produksi": 2022,
    "warna": "Hitam",
    "status": "baik",
    "perangkat_daerah_id": 1,
    "penanggung_jawab_id": 1
  }
}
```

Validasi yang gagal mengembalikan HTTP `422` beserta objek `errors`; data tidak ditemukan mengembalikan HTTP `404`.

Panduan seluruh perintah CRUD `curl`, filter, pagination, dan header API key production tersedia di [docs/API.md](docs/API.md).

## Penggunaan AI

Proyek ini dapat dikembangkan dengan **Codex menggunakan model GPT Terra** sebagai asisten implementasi.

1. Baca `AGENTS.md` dan `README.md` sebelum mengubah kode.
2. Berikan tugas yang spesifik, misalnya: “Tambahkan riwayat perawatan kendaraan, lengkap dengan migrasi, endpoint API, antarmuka, dan test.”
3. Minta AI menjelaskan asumsi yang mengubah aturan bisnis atau relasi data.
4. Jalankan test dan pemeriksaan database setelah perubahan. Tinjau diff sebelum melakukan commit.
5. Jangan memasukkan NIP produksi, kata sandi, token, atau kredensial ke prompt. Gunakan data contoh atau variabel lingkungan.

Contoh prompt:

> Tambahkan filter status dan perangkat daerah pada daftar kendaraan KDO. Pertahankan endpoint REST yang ada, tambahkan test, dan jalankan seluruh test suite.

## Struktur penting

- `app/models`: relasi dan validasi domain.
- `app/controllers`: pengendali halaman web dan API REST.
- `app/views`: antarmuka CRUD server-rendered.
- `db/migrate`: struktur SQLite dan constraint data.
- `AGENTS.md`: instruksi untuk asisten AI yang mengerjakan proyek.
- `docs/MANUAL_SETUP.md`: panduan instalasi dan demonstrasi aplikasi.
- `docs/API.md`: kontrak endpoint REST API.
- `db/dumps/kdo_sample.sql`: dump SQLite data demonstrasi fiktif.

## Peningkatan untuk penilaian

- Filter dan pagination tersedia pada seluruh daftar web serta endpoint collection API.
- Dasbor menampilkan status, distribusi kendaraan per perangkat daerah, dan biaya perawatan per bulan.
- Fitur bisnis tambahan mencatat riwayat perawatan, menghitung total biaya per kendaraan, total biaya keseluruhan, dan menampilkan tren biaya pada dasbor.
- Seluruh halaman termasuk formulir, tabel, navigasi, dasbor, dan halaman masuk dirancang responsif untuk desktop, tablet, dan ponsel.
- Lihat [ERD](docs/ERD.md), [evaluasi implementasi](docs/EVALUASI.md), dan [manual setup](docs/MANUAL_SETUP.md) untuk bukti desain dan verifikasi.
