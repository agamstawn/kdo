# Evaluasi Implementasi KDO

Dokumen ini memetakan implementasi terhadap komponen penilaian proyek. Nilai akhir tetap menjadi kewenangan penilai; dokumen ini menyajikan bukti fitur yang dapat diperiksa.

## 1. Komponen inti

| Aspek | Implementasi dan bukti |
| --- | --- |
| Kesesuaian fungsional | KDO mengelola perangkat daerah, pegawai, kendaraan, kondisi, penanggung jawab, dan riwayat perawatan. Lihat [ERD](ERD.md). |
| Kebenaran relasi | Foreign key, association Rails, validasi penanggung jawab satu perangkat daerah, serta pembatasan hapus menjaga konsistensi data. |
| Kualitas struktur | Model menyimpan aturan domain, controller memisahkan web dan `Api::V1`, concern menangani pagination dan autentikasi. |
| Git | Perubahan fitur dibuat dalam commit bertema (`feat`, `fix`, `docs`) agar mudah ditinjau melalui riwayat Git. |
| Dokumentasi | README, manual setup, API, ERD, evaluasi, screenshot, AGENTS, dan dump SQLite tersedia di repository. |

## 2. Komponen track frontend

| Aspek | Implementasi |
| --- | --- |
| Kelengkapan tampilan | Tersedia daftar, detail, form, ubah, hapus, login, dan dasbor untuk seluruh entitas. |
| UI/UX | Tombol aksi sejajar, tombol kembali tersedia di detail, pesan validasi ditampilkan, status dibedakan secara visual, dan navigasi konsisten. |
| Dasbor | Memuat ringkasan aset, komposisi kondisi, tren biaya enam bulan, prioritas kendaraan, distribusi per perangkat daerah, data perawatan terbaru, serta kendaraan terbaru. |
| Responsivitas | Tata letak, form, tabel, kartu, dan navigasi menyesuaikan desktop, tablet, serta ponsel. |
| Bukti visual | Lihat [SCREENSHOTS.md](SCREENSHOTS.md). |

## 3. Komponen track backend

| Aspek | Implementasi |
| --- | --- |
| REST API | CRUD JSON versi 1 untuk empat resource di `/api/v1`. |
| Endpoint | URL sederhana: `/perangkat-daerah`, `/pegawai`, `/kendaraan`, dan `/perawatan`. |
| Validasi/error | Strong parameters, validasi Active Record, `404` untuk data tidak ditemukan, `422` untuk data tidak valid/referensi terikat, `401` untuk API key salah, dan `503` bila API key production belum dikonfigurasi. |
| Keamanan dasar | Web memakai autentikasi sesi dengan `has_secure_password`, reset sesi saat masuk/keluar, serta rate limit login dasar. API production memakai `X-API-Key` dan perbandingan aman. |
| Dokumentasi API | Filter, pagination, payload, kode respons, dan contoh curl CRUD tercantum pada [API.md](API.md). |
| Pengujian | Test memeriksa model, autentikasi, detail web, dan CRUD API termasuk validasi/error. |

## 4. Nilai tambah

| Nilai tambah | Implementasi |
| --- | --- |
| Integrasi full-stack | Form dan halaman web menggunakan aturan model yang sama dengan REST API; perubahan perawatan memengaruhi detail kendaraan serta dasbor. |
| RDBMS | Skema memiliki foreign key, indeks unik, relasi eksplisit, dan artefak `db/dumps/kdo_sample.sql`. |
| Data bervariasi | Seed menyediakan armada pada tiga perangkat daerah dengan tiga kondisi dan 12 riwayat biaya dari beberapa bulan. |
| Fitur bisnis relevan | Riwayat perawatan merekam pekerjaan dan biaya; aplikasi menghitung total biaya per kendaraan dan keseluruhan serta menonjolkan kendaraan yang membutuhkan tindak lanjut. |
| Detail relasional | Detail perangkat daerah memperlihatkan nama pegawai serta nomor polisi dan nama kendaraan yang terkait. |

## Verifikasi yang direkomendasikan

```bash
bin/rails db:prepare
bin/rails db:seed
bin/rails test
bin/rails routes
bin/rails db:migrate:status
```

Untuk verifikasi manual, ikuti [MANUAL_SETUP.md](MANUAL_SETUP.md) dan jalankan setiap curl pada [API.md](API.md) dari terminal kedua.

## Batasan yang disadari

- API key adalah perlindungan dasar production, bukan pengganti otorisasi berbasis peran atau token per pengguna.
- Belum ada peran pengguna, unggahan dokumen perawatan, audit trail perubahan, maupun notifikasi jadwal servis.
- Pagination memakai implementasi internal ringan agar dependensi tetap minimal.
- Dump SQLite adalah artefak demonstrasi; `db:prepare` dan `db:seed` tetap cara utama untuk membangun database aplikasi saat ini.

Peningkatan lanjutan yang paling relevan adalah menambahkan peran/otorisasi, audit trail, lampiran bukti perawatan, dan notifikasi jadwal servis.

