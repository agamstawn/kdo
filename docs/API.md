# Dokumentasi REST API KDO

Base URL lokal: `http://localhost:3000/api/v1`. Semua request dan respons memakai JSON.

## Keamanan dan error

- API tidak menggunakan sesi login pengguna. Pada development dan test, API dapat dipakai langsung agar mudah diuji dari terminal kedua.
- Pada production, seluruh endpoint API mewajibkan header `X-API-Key` yang nilainya sama dengan environment variable `KDO_API_KEY`.
- Simpan API key production di secret manager atau environment deployment; jangan memasukkannya ke Git, dokumentasi, atau prompt AI.
- `401` menandakan API key tidak valid, `404` data tidak ditemukan, dan `422` validasi gagal.
- Respons validasi memakai bentuk `{ "errors": { "field": ["pesan"] } }`.

Untuk production, tambahkan `-H "X-API-Key: $KDO_API_KEY"` pada setiap perintah `curl` di bawah. Contoh pengaturan lokal yang aman:

```bash
export KDO_API_KEY='nilai-key-dari-secret-manager'
```

## Endpoint

| Resource | Collection | Member |
| --- | --- | --- |
| Perangkat daerah | `GET`, `POST /perangkat-daerah` | `GET`, `PATCH`, `DELETE /perangkat-daerah/:id` |
| Pegawai | `GET`, `POST /pegawai` | `GET`, `PATCH`, `DELETE /pegawai/:id` |
| Kendaraan dinas | `GET`, `POST /kendaraan` | `GET`, `PATCH`, `DELETE /kendaraan/:id` |
| Riwayat perawatan | `GET`, `POST /perawatan` | `GET`, `PATCH`, `DELETE /perawatan/:id` |

## Filter dan pagination collection

Semua endpoint collection menerima `page` dan `per_page` (maksimum 50), lalu mengembalikan metadata berikut:

```json
{ "data": [], "meta": { "page": 1, "per_page": 10, "total_count": 0, "total_pages": 1 } }
```

Filter yang tersedia: `q` untuk semua collection; `perangkat_daerah_id` untuk pegawai/kendaraan; `status` untuk kendaraan; dan `kendaraan_dinas_id` untuk riwayat perawatan.

## Uji manual dengan curl

Jalankan server pada terminal pertama dengan `bin/rails server`, lalu jalankan perintah berikut pada terminal kedua. Contoh memakai ID data seed `1`; ganti variabel ID sesuai respons API atau data lokal Anda.

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

# PATCH
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

# PATCH
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

# PATCH
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

# PATCH
curl -sS -X PATCH "$API_BASE/perawatan/$PERAWATAN_ID" -H 'Content-Type: application/json' \
  -d '{"riwayat_perawatan":{"biaya":1350000,"keterangan":"Penggantian oli, pemeriksaan rem, dan rotasi ban."}}'

# DELETE — hapus hanya data perawatan uji
curl -sS -i -X DELETE "$API_BASE/perawatan/$PERAWATAN_ID"
```

Untuk mencoba perintah `POST` berulang kali, ganti nilai yang harus unik seperti `nama`, `nip`, atau `nomor_polisi`.
