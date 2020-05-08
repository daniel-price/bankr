import 'package:bankr/model/access_token.dart';

class AccessTokenJsonConverter {
  AccessToken fromMap(Map<String, dynamic> map) {
    return AccessToken(
        map['accessToken'] as String,
        DateTime.fromMillisecondsSinceEpoch(map['expiresAt'] as int),
        map['tokenType'] as String,
        map['refreshToken'] as String,
        map['scope'] as String,
        map['id'] as int);
  }

  Map<String, dynamic> toMap(AccessToken accessToken) {
    return <String, dynamic>{
      'id': accessToken.id,
      'accessToken': accessToken.accessToken,
      'expiresAt': accessToken.expiresAt.millisecondsSinceEpoch,
      'tokenType': accessToken.tokenType,
      'refreshToken': accessToken.refreshToken,
      'scope': accessToken.scope,
    };
  }
}
