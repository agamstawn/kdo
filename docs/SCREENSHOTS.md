# Bukti Tampilan Aplikasi KDO

Tangkapan berikut dibuat dari lingkungan demonstrasi lokal dengan data seed fiktif. Nilai dan identitas di dalam gambar bukan data operasional atau kredensial production.

## Halaman masuk

Halaman masuk mengarahkan pengguna untuk mengakses aplikasi melalui sesi pengguna.

![Halaman masuk KDO](screenshots/fullstack/fe-login.png)

## Dasbor utama

Dasbor menampilkan ringkasan total armada, persentase kondisi baik, kendaraan yang perlu perhatian, total biaya perawatan, komposisi kondisi, dan tren biaya enam bulan.

![Dasbor KDO dengan ringkasan dan grafik](screenshots/fullstack/fe-dashboard.png)

## Dasbor lanjutan

Bagian lanjutan dasbor menunjukkan kendaraan prioritas, distribusi armada per perangkat daerah, riwayat perawatan terbaru, dan kendaraan terbaru.

![Bagian lanjutan dasbor KDO](screenshots/fullstack/fe-dashboard-2.png)

## Daftar, pencarian, filter, dan pagination

Setiap daftar menyediakan pencarian, filter yang relevan, pagination, serta aksi Detail/Ubah/Hapus yang konsisten.

### Kendaraan

![Daftar kendaraan dinas](screenshots/fullstack/fe-list-kendaraan-dinas.png)

### Pegawai

![Daftar pegawai](screenshots/fullstack/fe-list-pegawai.png)

### Perangkat daerah

![Daftar perangkat daerah](screenshots/fullstack/fe-list-perangkat-daerah.png)

### Riwayat perawatan

![Daftar riwayat perawatan](screenshots/fullstack/fe-list-riwayat-perawatan.png)

## Formulir responsif

Formulir menampilkan label, bantuan validasi, dan pemilihan relasi yang sesuai dengan aturan domain.

### Form kendaraan

![Form kendaraan](screenshots/fullstack/fe-form-kendaraan.png)

### Form pegawai

![Form pegawai](screenshots/fullstack/fe-form-pegawai.png)

### Form perangkat daerah

![Form perangkat daerah](screenshots/fullstack/fe-form-perangkat-daerah.png)

## Halaman detail

Halaman detail menyediakan tombol kembali ke daftar entitas serta tombol ubah. Detail perangkat daerah memperlihatkan relasi pegawai dan kendaraan.

### Detail kendaraan

![Detail kendaraan](screenshots/fullstack/fe-detail-kendaraan.png)

### Detail pegawai

![Detail pegawai](screenshots/fullstack/fe-detail-pegawai.png)

### Detail perangkat daerah

![Detail perangkat daerah](screenshots/fullstack/fe-detail-perangkat-daerah.png)

## Cakupan tampilan lain

Selain tampilan di atas, aplikasi menyediakan daftar, filter, pagination, form, detail, ubah, dan hapus pada Perangkat Daerah, Pegawai, Kendaraan, serta Perawatan. Detail perangkat daerah menampilkan nama pegawai dan nomor polisi beserta nama kendaraan yang terkait.
