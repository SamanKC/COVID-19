import 'package:http/http.dart' as http;

class Api {
  Future getData(String url) async {
    var response = await http.get(url, headers: {'Accept': 'application/json'});
    return response;
  }
}
