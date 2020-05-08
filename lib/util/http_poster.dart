import 'dart:convert';

import 'package:http/http.dart';

//TODO - replace with Dio?

class HttpPoster {
  final Client _client;

  HttpPoster(this._client);

  dynamic doPostAndGetJsonResponse (String url, Map<String, dynamic> body)
  async {
    final response = await _client.post(url, body: body);

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON.
      return json.decode(response.body);
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }
}