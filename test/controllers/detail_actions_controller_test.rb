require "test_helper"

class DetailActionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email_address: "detail@example.test", password: "SandiAman-2026!", password_confirmation: "SandiAman-2026!")
    @perangkat_daerah = PerangkatDaerah.create!(nama: "Dinas Detail")
    @pegawai = Pegawai.create!(nama: "Pegawai Detail", nip: "199501012026011001", jabatan: "Analis", golongan: "III/a", perangkat_daerah: @perangkat_daerah)
    @kendaraan = KendaraanDinas.create!(nomor_polisi: "B 9000 DTL", merek: "Toyota", model: "Avanza", tahun_produksi: 2022, warna: "Putih", status: :baik, perangkat_daerah: @perangkat_daerah, penanggung_jawab: @pegawai)
    @riwayat = RiwayatPerawatan.create!(kendaraan_dinas: @kendaraan, tanggal: Date.current, jenis: "Servis berkala", keterangan: "Pemeriksaan rutin", biaya: 500_000)

    post session_url, params: { email_address: @user.email_address, password: "SandiAman-2026!" }
  end

  test "each CRUD index provides a detail action" do
    [perangkat_daerahs_url, pegawais_url, kendaraan_dinas_index_url, riwayat_perawatans_url].each do |path|
      get path

      assert_response :success
      assert_select "td.actions a", "Detail"
    end
  end

  test "each entity detail page renders" do
    get perangkat_daerah_url(@perangkat_daerah)
    assert_response :success
    assert_select "h1", @perangkat_daerah.nama
    assert_select "a", "Kembali ke perangkat daerah"

    get pegawai_url(@pegawai)
    assert_response :success
    assert_select "h1", @pegawai.nama
    assert_select "a", "Kembali ke pegawai"

    get show_kendaraan_url(@kendaraan)
    assert_response :success
    assert_select "h1", @kendaraan.nomor_polisi
    assert_select "a", "Kembali ke kendaraan"

    get riwayat_perawatan_url(@riwayat)
    assert_response :success
    assert_select "h1", @riwayat.jenis
    assert_select "a", "Kembali ke perawatan"
  end
end
