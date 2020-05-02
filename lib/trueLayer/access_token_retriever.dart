import 'package:bankr/Configuration.dart';
import 'package:bankr/model/access_token.dart';
import 'package:bankr/util/http_poster.dart';

class TLAccessTokenRetriever {
  final String code;

  TLAccessTokenRetriever(this.code);

  Future<AccessToken> retrieve() async {
    var json = await getJsonFromTL();
    return accessTokenFromTLJson(json);
  }

  static AccessToken accessTokenFromTLJson(json) {
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

  getJsonFromTL() async {
    var map = new Map<String, dynamic>();
    map["grant_type"] = "authorization_code";
    map["client_id"] = Configuration.IDENTIFIER;
    map["client_secret"] = Configuration.SECRET;
    map["redirect_uri"] = Configuration.REDIRECT_URL;
    map["code"] = code;

    return await HttpPoster(Configuration.CREATE_POST_URL, map)
        .doPostAndGetJsonResponse();
  }
}
