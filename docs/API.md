# Dokumentasi REST API KDO

Base URL: `/api/v1`. Semua request dan respons memakai JSON.

## Keamanan dan error

- Development dan test tidak membutuhkan API key agar demonstrasi mudah dijalankan.
- Production mewajibkan header `X-API-Key` yang sama dengan environment variable `KDO_API_KEY`.
- `401` untuk key tidak valid, `404` untuk data tidak ditemukan, dan `422` untuk validasi gagal.
- Respons validasi memakai bentuk `{ "errors": { "field": ["pesan"] } }`.

## Endpoint

| Resource | Collection | Member |
| --- | --- | --- |
| Perangkat daerah | `GET`, `POST /perangkat-daerah` | `GET`, `PATCH`, `DELETE /perangkat-daerah/:id` |
| Pegawai | `GET`, `POST /pegawai` | `GET`, `PATCH`, `DELETE /pegawai/:id` |
| Kendaraan dinas | `GET`, `POST /kendaraan` | `GET`, `PATCH`, `DELETE /kendaraan/:id` |
| Riwayat perawatan | `GET`, `POST /perawatan` | `GET`, `PATCH`, `DELETE /perawatan/:id` |

Tambahkan prefix `/api/v1` pada seluruh path pada tabel.

## Filter dan pagination collection

Semua endpoint collection menerima `page` dan `per_page` (maksimum 50), lalu mengembalikan metadata berikut:

```json
{ "data": [], "meta": { "page": 1, "per_page": 10, "total_count": 0, "total_pages": 1 } }
```

Filter yang tersedia: `q` untuk semua collection; `perangkat_daerah_id` untuk pegawai/kendaraan; `status` untuk kendaraan; dan `kendaraan_dinas_id` untuk riwayat perawatan.

## Payload kendaraan

```json
{
  "kendaraan_dinas": {
    "nomor_polisi": "B 1234 KDO",
    "merek": "Toyota",
    "model": "Innova Reborn",
    "tahun_produksi": 2022,
    "warna": "Hitam",
    "status": "baik",
    "perangkat_daerah_id": 1,
    "penanggung_jawab_id": 1
  }
}
```

`status` hanya menerima `baik`, `rusak_ringan`, atau `rusak_berat`. Penanggung jawab wajib berasal dari perangkat daerah yang sama dengan kendaraan.

## Payload riwayat perawatan

```json
{
  "riwayat_perawatan": {
    "kendaraan_dinas_id": 1,
    "tanggal": "2026-10-22",
    "jenis": "Servis berkala",
    "keterangan": "Penggantian oli dan pemeriksaan rem.",
    "biaya": 1250000
  }
}
```

`biaya` opsional, tetapi jika diisi tidak boleh bernilai negatif.
