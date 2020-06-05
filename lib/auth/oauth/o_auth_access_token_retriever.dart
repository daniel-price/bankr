import 'package:bankr/auth/access_token.dart';
import 'package:bankr/util/http.dart';

class OAuthAccessTokenRetriever {
  final Http _http;
  final String _url;

  OAuthAccessTokenRetriever(this._http, this._url);

  Future<AccessToken> retrieve(Map<String, String> map) async {
    Map<String, dynamic> json = await _http.doPostAndGetJsonResponse(_url, map);
    return _fromMap(json);
  }

  AccessToken _fromMap (Map<String, dynamic> json)
  {
    if (json == null)
    {
      return null;
    }

    String accessToken = json['access_token'] as String;
    int expiresIn = json['expires_in'] as int;
    Duration expiresInDuration = Duration(seconds: expiresIn);
    var expiresAt = DateTime.now().add(expiresInDuration);
    String tokenType = json['token_type'] as String;
    String refreshToken = json['refresh_token'] as String;
    String scope = json['scope'] as String;

    return AccessToken(accessToken, expiresAt, tokenType, refreshToken, scope);
  }
}
