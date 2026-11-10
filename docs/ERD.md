# Entity Relationship Diagram (ERD)

```mermaid
erDiagram
  PERANGKAT_DAERAH ||--o{ PEGAWAI : menaungi
  PERANGKAT_DAERAH ||--o{ KENDARAAN_DINAS : memiliki
  PEGAWAI ||--o{ KENDARAAN_DINAS : bertanggung_jawab
  KENDARAAN_DINAS ||--o{ RIWAYAT_PERAWATAN : memiliki

  PERANGKAT_DAERAH {
    integer id PK
    string nama UK
  }
  PEGAWAI {
    integer id PK
    string nama
    string nip UK
    string jabatan
    string golongan
    integer perangkat_daerah_id FK
  }
  KENDARAAN_DINAS {
    integer id PK
    string nomor_polisi UK
    string merek
    string model
    integer tahun_produksi
    string warna
    integer status
    integer perangkat_daerah_id FK
    integer penanggung_jawab_id FK
  }
  RIWAYAT_PERAWATAN {
    integer id PK
    integer kendaraan_dinas_id FK
    date tanggal
    string jenis
    text keterangan
    decimal biaya
  }
```

## Aturan integritas

- Nama perangkat daerah dan NIP pegawai unik.
- Nomor polisi kendaraan unik.
- Kendaraan harus mempunyai perangkat daerah dan pegawai penanggung jawab.
- Pegawai penanggung jawab harus berasal dari perangkat daerah yang sama dengan kendaraan.
- Riwayat perawatan harus menunjuk kendaraan yang valid.
- Penghapusan perangkat daerah, pegawai, atau kendaraan yang masih memiliki relasi aktif ditolak oleh aplikasi.
