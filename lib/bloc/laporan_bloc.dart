import 'dart:convert';
import 'package:responsi1/helpers/api.dart';
import 'package:responsi1/helpers/api_url.dart';
import 'package:responsi1/models/laporan.dart'; 

class LaporanBloc {
  // Function to fetch monthly reports
  static Future<List<Laporan>> getLaporans() async {
    String apiUrl = ApiUrl.listLaporan;
    var response = await Api().get(apiUrl);

    if (response.statusCode == 200) {
      var jsonObj = json.decode(response.body);
      List<dynamic> listLaporan = (jsonObj as Map<String, dynamic>)['data'];
      List<Laporan> laporans = listLaporan.map((item) => Laporan.fromJson(item)).toList();
      return laporans;
    } else {
      throw Exception('Failed to load laporan: ${response.reasonPhrase}');
    }
  }

  // Function to add a new report
  static Future<bool> addLaporan({
    required String month,
    required int income,
    required int expenses,
  }) async {
    String apiUrl = ApiUrl.createLaporan;

    var body = {
      "month": month,
      "income": income.toString(),
      "expenses": expenses.toString(),
    };

    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);
    return jsonObj['status'] == 'success'; // Assuming 'status' indicates success
  }

  // Function to update a report
  static Future<bool> updateLaporan({
    required Laporan laporan,
    required String month,
    required int income,
    required int expenses,
  }) async {
    String apiUrl = ApiUrl.updateLaporan(int.parse(laporan.id!));

    var body = {
      "month": month,
      "income": income.toString(),
      "expenses": expenses.toString(),
    };

    var response = await Api().put(apiUrl, jsonEncode(body));
    var jsonObj = json.decode(response.body);
    return jsonObj['status'] == 'success'; // Assuming 'status' indicates success
  }

  // Function to delete a report by ID
  static Future<bool> deleteLaporan({required int id}) async {
    String apiUrl = ApiUrl.deleteLaporan(id);

    var response = await Api().delete(apiUrl);
    var jsonObj = json.decode(response.body);
    return (jsonObj as Map<String, dynamic>)['status'] == 'success'; // Assuming 'status' indicates success
  }
}
