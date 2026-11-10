# Evaluasi Implementasi KDO

## Cakupan fungsional

- CRUD web dan REST API untuk Perangkat Daerah, Pegawai, Kendaraan Dinas, dan Riwayat Perawatan.
- Filter dan pagination pada seluruh daftar web/API.
- Dasbor kondisi kendaraan, kendaraan per perangkat daerah, biaya perawatan per bulan, serta data terbaru.
- Detail kendaraan dengan total biaya dan seluruh riwayat perawatan.

## Keputusan teknis

- SQLite dipakai untuk development dan evaluasi agar setup lokal ringan.
- Foreign key, indeks, dan constraint unik menjaga relasi serta identitas data.
- Validasi model menjadi sumber aturan bisnis untuk web dan API.
- API v1 mengembalikan metadata pagination pada endpoint collection.
- API production menggunakan `KDO_API_KEY`; nilai rahasia tidak disimpan dalam repository.

## Bukti verifikasi

Jalankan:

```bash
bin/rails test
bin/rails db:prepare db:seed
sqlite3 /tmp/kdo_sample.sqlite3 < db/dumps/kdo_sample.sql
```

Test mencakup aturan relasi kendaraan, validasi riwayat perawatan, render halaman, serta lifecycle API create/read/update/delete dan error validasi. Dump SQLite berisi data demonstrasi fiktif tanpa data personal lokal.

## Batasan saat ini

- Aplikasi belum memakai autentikasi pengguna; API key production adalah perlindungan dasar untuk endpoint API.
- Pagination memakai implementasi internal ringan, bukan library eksternal.
- Screenshot dan deployment publik perlu dilengkapi oleh pemilik proyek saat penyerahan.
