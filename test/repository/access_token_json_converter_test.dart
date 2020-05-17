import 'package:bankr/json/model_json_converters.dart';
import 'package:bankr/model/access_token_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  String _accessToken = "acc tok";
  DateTime _expiresAt = DateTime(2010);
  String _tokenType = "token type!";
  String _refreshToken = "ref tok test";
  String _scope = "The Scope";
  int _id = 12;

  AccessToken accessToken = AccessToken(
      _accessToken, _expiresAt, _tokenType, _refreshToken, _scope, _id);
  group('toMap and fromMap', () {
    test('checks that the map from an accessToken matches the accessToken', () {
      AccessTokenModelJsonConverter accessTokenJsonConverter = AccessTokenModelJsonConverter();
      Map<String, dynamic> map = accessTokenJsonConverter.toMap(accessToken);
      AccessToken accessTokenFromMap = accessTokenJsonConverter.fromMap(map);
      expect(accessTokenFromMap.accessToken, _accessToken);
      expect(accessTokenFromMap.expiresAt, _expiresAt);
      expect(accessTokenFromMap.tokenType, _tokenType);
      expect(accessTokenFromMap.refreshToken, _refreshToken);
      expect(accessTokenFromMap.scope, _scope);
	    expect(accessTokenFromMap.key, _id);
    });
  });
}
