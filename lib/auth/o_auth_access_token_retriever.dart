import 'package:bankr/json/i_json_converter.dart';
import 'package:bankr/model/access_token_model.dart';
import 'package:bankr/util/http.dart';

class OAuthAccessTokenRetriever {
  final Http _http;
  final String _url;
  final IJsonConverter<AccessToken> _accessTokenjsonConverter;

  OAuthAccessTokenRetriever(this._http, this._url, this._accessTokenjsonConverter);

  Future<AccessToken> retrieve(Map<String, String> map) async {
    Map<String, dynamic> json = await _http.doPostAndGetJsonResponse(_url, map);
    String error = json['error'] as String;
    if (error != null) {
      throw Exception(error);
    }

    return _accessTokenjsonConverter.fromMap(json);
  }
}
