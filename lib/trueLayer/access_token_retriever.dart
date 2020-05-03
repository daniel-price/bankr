import 'package:bankr/Configuration.dart';
import 'package:bankr/model/access_token.dart';
import 'package:bankr/util/http_poster.dart';

abstract class TLAccessTokenRetrieverI {
  Future<AccessToken> retrieve(String code);
}

class TLAccessTokenRetriever extends TLAccessTokenRetrieverI {
  final HttpPoster httpPoster;

  TLAccessTokenRetriever(this.httpPoster);

  Future<AccessToken> retrieve(String code) async {
    var map = new Map<String, dynamic>();
    map["grant_type"] = "authorization_code";
    map["client_id"] = Configuration.IDENTIFIER;
    map["client_secret"] = Configuration.SECRET;
    map["redirect_uri"] = Configuration.REDIRECT_URL;
    map["code"] = code;

    var json = await httpPoster.doPostAndGetJsonResponse(
        Configuration.CREATE_POST_URL, map);
    String error = json['error'];
    if (error != null) {
      print("Error getting access token: $error");
      return null;
    }

    var accessToken = json['access_token'];
    int expiresIn = json['expires_in'];
    Duration expiresInDuration = new Duration(seconds: expiresIn);
    var expiresAt = DateTime.now().add(expiresInDuration);
    var tokenType = json['token_type'];
    var refreshToken = json['refresh_token'];
    var scope = json['scope'];

    return AccessToken(accessToken, expiresAt, tokenType, refreshToken, scope);
  }
}

class TLAccessTokenRetrieverMock extends TLAccessTokenRetrieverI {
  Future<AccessToken> retrieve(String code) async {
    return AccessToken(
        code, DateTime.now(), "tokenType", "refreshToken", "scope");
  }
}
