class ApiUrl {
  static const String baseUrl = 'http://103.196.155.42/api';

  static const String registrasi = '$baseUrl/registrasi';
  static const String login = '$baseUrl/login';
  static const String listLaporan = '$baseUrl/keuangan/laporan_keuangan';
  static const String createLaporan = '$baseUrl/keuangan/laporan_keuangan';

  static String updateLaporan(int id) {
    return '$baseUrl/keuangan/laporan_keuangan/$id';
  }

  static String showLaporan(int id) {
    return '$baseUrl/keuangan/laporan_keuangan/$id'; 
  }

  static String deleteLaporan(int id) {
    return '$baseUrl/keuangan/laporan_keuangan/$id';
  }
}
