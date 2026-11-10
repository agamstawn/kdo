# Dokumentasi REST API KDO

Base URL lokal: `http://localhost:3000/api/v1`. Semua request dan respons memakai JSON. API dipisahkan dari sesi browser agar dapat diuji dari terminal atau diintegrasikan oleh klien lain.

## Keamanan dan error

- API tidak menggunakan sesi login pengguna. Pada development dan test, API dapat dipakai langsung agar mudah diuji dari terminal kedua.
- Pada production, seluruh endpoint API mewajibkan header `X-API-Key` yang nilainya sama dengan environment variable `KDO_API_KEY`.
- Simpan API key production di secret manager atau environment deployment; jangan memasukkannya ke Git, dokumentasi, atau prompt AI.
- `401` menandakan API key tidak valid, `404` data tidak ditemukan, `422` validasi gagal atau penghapusan ditolak oleh relasi aktif, dan `503` berarti API key production belum dikonfigurasi.
- Respons validasi memakai bentuk `{ "errors": { "field": ["pesan"] } }`.

Untuk production, tambahkan `-H "X-API-Key: $KDO_API_KEY"` pada setiap perintah `curl` di bawah. Contoh pengaturan lokal yang aman:

```bash
export KDO_API_KEY='ambil-dari-secret-manager'
```

Jangan menjalankan contoh `export` tersebut dengan nilai rahasia asli pada shell yang direkam, dibagikan, atau disimpan ke riwayat.

## Endpoint

| Resource | Collection | Member |
| --- | --- | --- |
| Perangkat daerah | `GET`, `POST /perangkat-daerah` | `GET`, `PATCH`, `DELETE /perangkat-daerah/:id` |
| Pegawai | `GET`, `POST /pegawai` | `GET`, `PATCH`, `DELETE /pegawai/:id` |
| Kendaraan dinas | `GET`, `POST /kendaraan` | `GET`, `PATCH`, `DELETE /kendaraan/:id` |
| Riwayat perawatan | `GET`, `POST /perawatan` | `GET`, `PATCH`, `DELETE /perawatan/:id` |

Status keberhasilan: `200 OK` untuk `GET`/`PATCH`, `201 Created` untuk `POST`, dan `204 No Content` untuk `DELETE`. Operasi yang mengirim body (`POST`/`PATCH`) harus memakai header `Content-Type: application/json` dan root JSON sesuai nama resource.

## Filter dan pagination collection

Semua endpoint collection menerima `page` dan `per_page` (maksimum 50), lalu mengembalikan metadata berikut:

```json
{ "data": [], "meta": { "page": 1, "per_page": 10, "total_count": 0, "total_pages": 1 } }
```

| Resource | Filter |
| --- | --- |
| Semua collection | `q` (pencarian teks), `page`, `per_page` |
| Pegawai | `perangkat_daerah_id` |
| Kendaraan | `perangkat_daerah_id`, `status` (`baik`, `rusak_ringan`, `rusak_berat`) |
| Perawatan | `kendaraan_dinas_id` |

Nilai `per_page` dibatasi maksimal 50. Nilai halaman yang kurang dari 1 dinormalisasi menjadi 1.

## Bentuk payload

| Resource | Root JSON | Atribut yang diterima |
| --- | --- | --- |
| Perangkat daerah | `perangkat_daerah` | `nama` |
| Pegawai | `pegawai` | `nama`, `nip`, `jabatan`, `golongan`, `perangkat_daerah_id` |
| Kendaraan | `kendaraan_dinas` | `nomor_polisi`, `merek`, `model`, `tahun_produksi`, `warna`, `status`, `perangkat_daerah_id`, `penanggung_jawab_id` |
| Perawatan | `riwayat_perawatan` | `kendaraan_dinas_id`, `tanggal`, `jenis`, `keterangan`, `biaya` |

Respons collection berbentuk `{ "data": [...], "meta": { ... } }`; respons member berbentuk objek resource. Respons `422` berbentuk `{ "errors": { "field": ["pesan"] } }` dan `404` berbentuk `{ "error": "Data tidak ditemukan" }`.

## Uji manual dengan curl

Jalankan server pada terminal pertama dengan `bin/rails server`, lalu jalankan perintah berikut pada terminal kedua. Contoh memakai ID data seed `1`; ganti variabel ID sesuai respons API atau data lokal Anda. Untuk aman, buat data melalui `POST`, simpan ID responsnya, lalu gunakan hanya data tersebut untuk contoh `PATCH` dan `DELETE`.

```bash
export API_BASE='http://localhost:3000/api/v1'
export PERANGKAT_ID=1
export PEGAWAI_ID=1
export KENDARAAN_ID=1
export PERAWATAN_ID=1
```

### Perangkat daerah

```bash
# GET collection
curl -sS "$API_BASE/perangkat-daerah?page=1&per_page=10&q=Pendidikan"

# POST
curl -sS -X POST "$API_BASE/perangkat-daerah" -H 'Content-Type: application/json' \
  -d '{"perangkat_daerah":{"nama":"Dinas Lingkungan Hidup API"}}'

# GET member
curl -sS "$API_BASE/perangkat-daerah/$PERANGKAT_ID"

# PATCH — gunakan ID data uji, bukan data seed yang ingin dipertahankan
curl -sS -X PATCH "$API_BASE/perangkat-daerah/$PERANGKAT_ID" -H 'Content-Type: application/json' \
  -d '{"perangkat_daerah":{"nama":"Dinas Pendidikan Kabupaten"}}'

# DELETE — gunakan ID data uji yang tidak masih direlasikan
curl -sS -i -X DELETE "$API_BASE/perangkat-daerah/$PERANGKAT_ID"
```

### Pegawai

```bash
# GET collection dengan filter perangkat daerah
curl -sS "$API_BASE/pegawai?page=1&per_page=10&perangkat_daerah_id=$PERANGKAT_ID&q=Analis"

# POST
curl -sS -X POST "$API_BASE/pegawai" -H 'Content-Type: application/json' \
  -d '{"pegawai":{"nama":"Petugas API","nip":"199501012026011001","jabatan":"Analis Data","golongan":"III/a","perangkat_daerah_id":1}}'

# GET member
curl -sS "$API_BASE/pegawai/$PEGAWAI_ID"

# PATCH — gunakan ID data uji, bukan data seed yang ingin dipertahankan
curl -sS -X PATCH "$API_BASE/pegawai/$PEGAWAI_ID" -H 'Content-Type: application/json' \
  -d '{"pegawai":{"jabatan":"Analis Data Senior"}}'

# DELETE — gunakan ID pegawai uji yang tidak menjadi penanggung jawab kendaraan
curl -sS -i -X DELETE "$API_BASE/pegawai/$PEGAWAI_ID"
```

### Kendaraan dinas

`status` hanya menerima `baik`, `rusak_ringan`, atau `rusak_berat`. Penanggung jawab wajib berasal dari perangkat daerah yang sama dengan kendaraan.

```bash
# GET collection dengan filter kondisi dan perangkat daerah
curl -sS "$API_BASE/kendaraan?page=1&per_page=10&status=baik&perangkat_daerah_id=$PERANGKAT_ID&q=Toyota"

# POST
curl -sS -X POST "$API_BASE/kendaraan" -H 'Content-Type: application/json' \
  -d '{"kendaraan_dinas":{"nomor_polisi":"B 9001 API","merek":"Toyota","model":"Avanza","tahun_produksi":2024,"warna":"Putih","status":"baik","perangkat_daerah_id":1,"penanggung_jawab_id":1}}'

# GET member
curl -sS "$API_BASE/kendaraan/$KENDARAAN_ID"

# PATCH — gunakan ID data uji, bukan data seed yang ingin dipertahankan
curl -sS -X PATCH "$API_BASE/kendaraan/$KENDARAAN_ID" -H 'Content-Type: application/json' \
  -d '{"kendaraan_dinas":{"status":"rusak_ringan","warna":"Abu-abu"}}'

# DELETE — hanya dapat dilakukan jika kendaraan tidak memiliki riwayat perawatan
curl -sS -i -X DELETE "$API_BASE/kendaraan/$KENDARAAN_ID"
```

### Riwayat perawatan

`biaya` opsional, tetapi jika diisi tidak boleh bernilai negatif. Riwayat perawatan adalah fitur bisnis untuk mencatat pekerjaan perawatan dan menjadi sumber total maupun tren biaya pada dasbor.

```bash
# GET collection dengan filter kendaraan
curl -sS "$API_BASE/perawatan?page=1&per_page=10&kendaraan_dinas_id=$KENDARAAN_ID&q=servis"

# POST
curl -sS -X POST "$API_BASE/perawatan" -H 'Content-Type: application/json' \
  -d '{"riwayat_perawatan":{"kendaraan_dinas_id":1,"tanggal":"2026-11-10","jenis":"Servis berkala","keterangan":"Penggantian oli dan pemeriksaan rem.","biaya":1250000}}'

# GET member
curl -sS "$API_BASE/perawatan/$PERAWATAN_ID"

# PATCH — gunakan ID data uji, bukan data seed yang ingin dipertahankan
curl -sS -X PATCH "$API_BASE/perawatan/$PERAWATAN_ID" -H 'Content-Type: application/json' \
  -d '{"riwayat_perawatan":{"biaya":1350000,"keterangan":"Penggantian oli, pemeriksaan rem, dan rotasi ban."}}'

# DELETE — hapus hanya data perawatan uji
curl -sS -i -X DELETE "$API_BASE/perawatan/$PERAWATAN_ID"
```

Untuk mencoba perintah `POST` berulang kali, ganti nilai yang harus unik seperti `nama`, `nip`, atau `nomor_polisi`. Perintah `DELETE` untuk perangkat daerah, pegawai, atau kendaraan dapat mengembalikan `422` bila data tersebut masih direferensikan; ini merupakan perilaku integritas yang diharapkan.
