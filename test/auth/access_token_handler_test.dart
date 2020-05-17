import 'package:bankr/auth/o_auth_director.dart';
import 'package:bankr/model/access_token_model.dart';
import 'package:bankr/repository/i_dao.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'file:///C:/bankr/lib/access_token_store.dart';

class MockIOAuthenticator extends Mock implements OAuthDirector {
  @override
  Future<AccessToken> authenticate() async {
    return AccessToken("_accessToken", DateTime(2000), "_tokenType", "_refreshToken", "_scope");
  }

  @override
  Future<AccessToken> refresh(String refreshToken) async {
    return AccessToken("refreshedAccessToken", DateTime(2000), "_tokenType", "_refreshToken", "_scope");
  }
}

class MockRepository extends Mock implements IDao<AccessToken> {
  var accessTokens = List<AccessToken>();

  @override
  void insert(AccessToken saveableI) {
    accessTokens.add(saveableI);
  }

  @override
  Future<List<AccessToken>> getAll() async {
    return accessTokens;
  }
}

void main() {
  var mockIOAuthenticator = MockIOAuthenticator();
  var mockRepository = MockRepository();
  var accessTokenHandler = AccessTokenStore(mockIOAuthenticator, mockRepository);

  group('addAccessToken', () {
    test('generates and persists an access token', () async {
      await accessTokenHandler.addAccessToken();
      var accessTokens = await mockRepository.getAll();
      expect(
        accessTokens.length,
        1,
      );
    });
  });

  group('getAllAccessTokens', () {
    test('refreshes all access tokens and returns them', () async {
      await accessTokenHandler.addAccessToken();
      List<AccessToken> accessTokens = await accessTokenHandler.getAll();
      AccessToken refreshedAccessToken = accessTokens[0];
      expect(refreshedAccessToken.accessToken, "refreshedAccessToken");
    });
  });
}
