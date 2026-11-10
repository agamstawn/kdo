# Petunjuk AI untuk KDO

## Tujuan aplikasi

KDO mengelola kendaraan dinas operasional, PNS penanggung jawab, perangkat daerah, dan riwayat perawatan. Prioritaskan integritas data, keamanan dasar, pengalaman pengguna yang sederhana, serta REST API yang konsisten.

## Teknologi dan batasan

- Gunakan Ruby 3.2.0, Rails 8.1, dan SQLite untuk development/test; versi patch Rails mengikuti `Gemfile.lock`.
- Pertahankan aplikasi server-rendered Rails. Gunakan Turbo atau JavaScript ringan hanya bila meningkatkan interaksi pengguna secara nyata.
- Jangan menambah layanan eksternal, kredensial, token, API key, atau data pribadi produksi ke repository.
- Semua antarmuka dan dokumentasi ditulis dalam Bahasa Indonesia yang jelas.
- Jangan menjalankan operasi database destruktif, menghapus data, atau mengubah dependensi tanpa persetujuan pengguna.

## Aturan domain

- `PerangkatDaerah` memiliki banyak `Pegawai` dan `KendaraanDinas`.
- `Pegawai` wajib memiliki NIP unik 18 digit dan satu perangkat daerah.
- `KendaraanDinas` wajib memiliki nomor polisi unik, perangkat daerah, serta pegawai penanggung jawab dari perangkat daerah yang sama.
- Status kendaraan hanya `baik`, `rusak_ringan`, atau `rusak_berat`.
- `RiwayatPerawatan` wajib terkait dengan kendaraan; `biaya` boleh kosong tetapi tidak boleh negatif.
- Jangan menghapus perangkat daerah, pegawai, atau kendaraan yang masih memiliki relasi aktif. Tampilkan kesalahan yang dapat dipahami pengguna.
- `User` adalah akun teknis untuk autentikasi web, bukan otomatis identik dengan `Pegawai`.

## Rute dan kontrak yang harus dipertahankan

- Rute web: `/perangkat-daerah`, `/pegawai`, `/kendaraan`, `/perawatan`, dan `/sesi/new`.
- API berada di `/api/v1`: `/perangkat-daerah`, `/pegawai`, `/kendaraan`, `/perawatan`.
- Endpoint collection mendukung pagination (`page`, `per_page`, maksimum 50) dan filter yang terdokumentasi pada `docs/API.md`.
- API production mewajibkan `X-API-Key` yang cocok dengan `KDO_API_KEY`; gunakan placeholder dalam contoh dan jangan pernah menulis nilai production.
- Semua perubahan API harus mempertahankan respons JSON, kode HTTP yang tepat, dan memperbarui `docs/API.md` beserta test.

## Autentikasi dan keamanan

- Seluruh halaman web selain halaman sesi memerlukan autentikasi.
- Gunakan `has_secure_password`; jangan menyimpan kata sandi plaintext selain akun demo lokal yang sudah didokumentasikan.
- Pertahankan reset sesi saat masuk/keluar dan pembatasan percobaan masuk.
- Jangan menonaktifkan proteksi CSRF pada halaman web. Pengecualian hanya untuk API JSON sebagaimana konfigurasi yang sudah ada.
- Perlakukan NIP, email, password, token, dan API key sebagai data sensitif. Gunakan data fiktif/placeholder saat membuat contoh.

## Standar implementasi

- Gunakan strong parameters, validasi model, foreign key, indeks unik, dan respons error yang jelas.
- Tambahkan atau perbarui test ketika perilaku bisnis, relasi, endpoint, atau autentikasi berubah.
- Untuk UI CRUD, jaga konsistensi aksi Detail/Ubah/Hapus dan tombol kembali pada halaman detail.
- Untuk perubahan relasi, perbarui `docs/ERD.md`; untuk fitur/flow UI, perbarui README, manual, evaluasi, dan screenshot bila relevan.
- Jalankan `bin/rails db:prepare`, `bin/rails test`, `bin/rails routes`, dan `bin/rails db:migrate:status` sebelum menyatakan pekerjaan selesai.

## Cara kerja AI

1. Mulai dengan membaca `README.md`, `AGENTS.md`, dokumentasi terkait, dan kode yang akan diubah.
2. Jelaskan asumsi yang berdampak pada aturan bisnis, relasi, keamanan, atau data.
3. Gunakan patch kecil yang mudah ditinjau dan jangan menghapus perubahan pengguna yang tidak terkait.
4. Tinjau `git diff` dan hasil test sebelum commit.
5. Gunakan pesan commit berfokus pada satu perubahan, misalnya `feat: tambah ...`, `fix: perbaiki ...`, atau `docs: perbarui ...`.

