import 'package:bankr/json/i_json_converter.dart';
import 'package:bankr/model/access_token_model.dart';

class TrueLayerAccessTokenJsonConverter extends IJsonConverter<AccessToken> {
  AccessToken fromMap(Map<String, dynamic> json) {
    String accessToken = json['access_token'] as String;
    int expiresIn = json['expires_in'] as int;
    Duration expiresInDuration = Duration(seconds: expiresIn);
    var expiresAt = DateTime.now().add(expiresInDuration);
    String tokenType = json['token_type'] as String;
    String refreshToken = json['refresh_token'] as String;
    String scope = json['scope'] as String;

    return AccessToken(accessToken, expiresAt, tokenType, refreshToken, scope);
  }

  Map<String, dynamic> toMap(AccessToken accessToken) {
    throw UnimplementedError();
  }
}
