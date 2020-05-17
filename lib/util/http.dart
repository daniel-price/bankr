import 'dart:convert';

import 'package:http/http.dart';

//TODO - Consider replacing with Dio

class Http {
  final Client _client;

  Http(this._client);

  Future<Map<String, dynamic>> doPostAndGetJsonResponse(String url, Map<String, dynamic> body) async {
    final response = await _client.post(url, body: body);

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON.
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      // If that call was not successful, throw an error.
      print(response.body);
      throw Exception('Failed to load post');
    }
  }

  Future<Map<String, dynamic>> doGetAndGetJsonResponse(String url, Map<String, String> headers) async {
    final response = await _client.get(url, headers: headers);

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON.
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      // If that call was not successful, throw an error.
      print(response.body);
      throw Exception('Failed to load post');
    }
  }
}
