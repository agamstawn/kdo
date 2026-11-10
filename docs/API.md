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
| Perangkat daerah | `GET`, `POST /perangkat_daerahs` | `GET`, `PATCH`, `DELETE /perangkat_daerahs/:id` |
| Pegawai | `GET`, `POST /pegawais` | `GET`, `PATCH`, `DELETE /pegawais/:id` |
| Kendaraan dinas | `GET`, `POST /kendaraan_dinas` | `GET`, `PATCH`, `DELETE /kendaraan_dinas/:id` |
| Riwayat perawatan | `GET`, `POST /riwayat_perawatans` | `GET`, `PATCH`, `DELETE /riwayat_perawatans/:id` |

Tambahkan prefix `/api/v1` pada seluruh path pada tabel.

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
