import 'dart:convert';
import 'package:http/http.dart';

//TODO - replace with Dio?

class HttpPoster {
  final String _url;
  final Map<String, dynamic> _body;

  HttpPoster(this._url, this._body);

  doPostAndGetJsonResponse() {
    return post(_url, body: _body).then((Response response) {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400) {
        throw new Exception("Error while fetching data");
      }

      return json.decode(response.body);
    });
  }
}
