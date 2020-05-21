import 'dart:convert';

import 'package:http/http.dart';

//TODO - Consider replacing with Dio

class Http {
  final Client _client;

  Http(this._client);

  Future<Map<String, dynamic>> doPostAndGetJsonResponse(String url, Map<String, dynamic> body) async {
    final response = await _client.post(url, body: body);
    return _getJsonFromResponse(response);
  }

  Future<Map<String, dynamic>> doGetAndGetJsonResponse(String url, Map<String, String> headers) async {
    final response = await _client.get(url, headers: headers);
    return _getJsonFromResponse(response);
  }

  Future<Map<String, dynamic>> _getJsonFromResponse(Response response) async {
    if (response.statusCode != 200) {
      return null;
    }

    var jsonMap = json.decode(response.body) as Map<String, dynamic>;
    if (_containsError(jsonMap)) {
      return null;
    }

    return jsonMap;
  }

  bool _containsError(Map<String, dynamic> jsonMap) {
    String error = jsonMap['error'] as String;
    if (error != null) {
      print("Error retrieving json" + error);
      return true;
    }
    return false;
  }
}
