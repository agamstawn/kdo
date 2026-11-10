# Petunjuk AI untuk KDO

## Tujuan aplikasi

KDO mengelola Kendaraan Dinas Operasional, PNS penanggung jawab, dan Perangkat Daerah. Prioritaskan integritas data, pengalaman pengguna yang sederhana, serta API REST yang konsisten.

## Teknologi dan batasan

- Gunakan Ruby 3.2.0, Rails 8.1, dan SQLite untuk development/test; versi patch Rails mengikuti `Gemfile.lock`.
- Jangan menambah layanan eksternal, kredensial, atau data pribadi produksi.
- Pertahankan aplikasi server-rendered Rails; gunakan Turbo/JavaScript ringan hanya jika meningkatkan interaksi pengguna.
- Semua pesan antarmuka dan dokumentasi ditulis dalam Bahasa Indonesia yang jelas.

## Aturan domain

- `PerangkatDaerah` memiliki banyak `Pegawai` dan `KendaraanDinas`.
- `Pegawai` wajib memiliki NIP unik 18 digit dan satu perangkat daerah.
- `KendaraanDinas` wajib memiliki nomor polisi unik, perangkat daerah, serta pegawai penanggung jawab dari perangkat daerah yang sama.
- Status kendaraan hanya: `baik`, `perlu_perawatan`, `rusak`, atau `tidak_aktif`.
- Jangan menghapus perangkat daerah atau pegawai yang masih memiliki relasi aktif; tampilkan kesalahan yang dapat dipahami pengguna.

## Standar implementasi

- Gunakan strong parameters, validasi model, foreign key, indeks unik, dan respons JSON dengan kode HTTP yang tepat.
- Endpoint API harus berada di `/api/v1` dan mempertahankan pola CRUD REST.
- Tambahkan atau perbarui test saat mengubah perilaku bisnis.
- Jalankan `bin/rails db:prepare`, `bin/rails test`, dan `bin/rails routes` sebelum menyatakan pekerjaan selesai.
- Jangan mengubah dependensi atau skema database secara destruktif tanpa persetujuan pengguna.

## Cara kerja AI

- Mulai dengan membaca `README.md`, `AGENTS.md`, dan kode terkait.
- Jelaskan asumsi domain yang berdampak pada relasi atau data.
- Gunakan patch kecil yang mudah ditinjau; jangan menghapus perubahan pengguna yang tidak terkait.
- Bila diminta contoh konfigurasi rahasia, gunakan placeholder seperti `DATABASE_URL`, bukan nilai nyata.
