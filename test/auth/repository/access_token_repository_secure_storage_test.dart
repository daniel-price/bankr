import 'package:bankr/auth/access_token.dart';
import 'package:bankr/auth/repository/access_token_repository_secure_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';

class MockStorage extends Mock implements FlutterSecureStorage {
  Map<String, String> _map = Map();

  @override
  Future<void> write({String key, String value, IOSOptions iOptions, AndroidOptions aOptions}) async {
    _map[key] = value;
  }

  @override
  Future<Map<String, String>> readAll({IOSOptions iOptions, AndroidOptions aOptions}) async {
    return _map;
  }

  @override
  Future<void> delete({String key, IOSOptions iOptions, AndroidOptions aOptions}) async {
    _map.remove(key);
  }
}

class MockSharedPreferences extends Mock implements SharedPreferences {
  int lastKey;

  @override
  int getInt(String key) {
    return lastKey;
  }

  @override
  Future<bool> setInt(String key, int value) async {
    lastKey = value;
    return true;
  }
}

void main() {
  var mockStorage = MockStorage();
  var mockSharedPreferences = MockSharedPreferences();
  var accessTokenRepositorySecureStorage = AccessTokenRepositorySecureStorage(mockStorage, mockSharedPreferences);

  group('insert, update, getAll, delete', () {
    test('return an access token if the retrieve access token call returns valid json', () async {
      String accessToken1 = 'accessToken1';
      DateTime expiresAt1 = DateTime(2001);
      String tokenType1 = 'tokenType1';
      String refreshToken1 = 'refreshToken1';
      String scope1 = 'scope1';
      var firstAccessToken = AccessToken(accessToken1, expiresAt1, tokenType1, refreshToken1, scope1);

      String accessToken2 = 'accessToken2';
      DateTime expiresAt2 = DateTime(2002);
      String tokenType2 = 'tokenType2';
      String refreshToken2 = 'refreshToken2';
      String scope2 = 'scope2';
      var secondAccessToken = AccessToken(accessToken2, expiresAt2, tokenType2, refreshToken2, scope2);

      await accessTokenRepositorySecureStorage.insert(firstAccessToken);
      await accessTokenRepositorySecureStorage.insert(secondAccessToken);

      var accessTokens = await accessTokenRepositorySecureStorage.getAll();

      for (AccessToken accessToken in accessTokens) {
        if (accessToken.key == firstAccessToken.key) {
          expect(accessToken.accessToken, accessToken1);
          expect(accessToken.expiresAt, expiresAt1);
          expect(accessToken.tokenType, tokenType1);
          expect(accessToken.refreshToken, refreshToken1);
          expect(accessToken.scope, scope1);
        }
        if (accessToken.key == secondAccessToken.key) {
          expect(accessToken.accessToken, accessToken2);
          expect(accessToken.expiresAt, expiresAt2);
          expect(accessToken.tokenType, tokenType2);
          expect(accessToken.refreshToken, refreshToken2);
          expect(accessToken.scope, scope2);
        }
      }

      String accessToken3 = 'accessToken3';
      DateTime expiresAt3 = DateTime(2003);
      String tokenType3 = 'tokenType3';
      String refreshToken3 = 'refreshToken3';
      String scope3 = 'scope3';
      firstAccessToken = AccessToken(accessToken3, expiresAt3, tokenType3, refreshToken3, scope3, firstAccessToken.key);

      await accessTokenRepositorySecureStorage.update(firstAccessToken);
      await accessTokenRepositorySecureStorage.delete(secondAccessToken);

      var newAccessTokens = await accessTokenRepositorySecureStorage.getAll();
      expect(newAccessTokens.length, 1);
      var newAccessToken = newAccessTokens[0];
      expect(newAccessToken.accessToken, accessToken3);
      expect(newAccessToken.expiresAt, expiresAt3);
      expect(newAccessToken.tokenType, tokenType3);
      expect(newAccessToken.refreshToken, refreshToken3);
      expect(newAccessToken.scope, scope3);
    });
  });
}
