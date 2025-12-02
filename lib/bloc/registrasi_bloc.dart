import 'dart:convert';
import 'package:pertemuan_10_toko_api/helpers/api.dart';
import 'package:pertemuan_10_toko_api/helpers/api_url.dart';
import 'package:pertemuan_10_toko_api/model/registrasi.dart';

class RegistrasiBloc {
  static Future<Registrasi> registrasi({
    String? nama,
    String? email,
    String? password,
  }) async {
    String apiUrl = ApiUrl.registrasi;
    var body = {"nama": nama, "email": email, "password": password};

    // Mengirim request POST sebagai JSON, tanpa token
    var response = await Api().postWithoutToken(apiUrl, body);
    var jsonObj = json.decode(response.body);

    return Registrasi.fromJson(jsonObj);
  }
}
