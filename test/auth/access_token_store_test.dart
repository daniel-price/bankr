/*
import 'package:bankr/auth/access_token.dart';
import 'package:bankr/auth/access_token_store.dart';
import 'package:bankr/auth/oauth/o_auth_authenticator.dart';
import 'package:bankr/auth/repository/i_access_token_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockOAuthAuthenticator extends Mock implements OAuthAuthenticator {}

class MockAccessTokenRepository extends Mock implements IAccessTokenRepository {
  Map<String, AccessToken> accessTokens = Map();

  @override
  void insert(AccessToken accessToken) {
	  accessTokens[accessToken.uuid] = accessToken;
  }

  @override
  void update(AccessToken accessToken) {
	  accessTokens[accessToken.uuid] = accessToken;
  }

  @override
  Future<List<AccessToken>> getAll() async {
    return accessTokens.values.toList();
  }
}

void main() {
  var mockOAuthAuthenticator = MockOAuthAuthenticator();
  var mockAccessTokenRepository = MockAccessTokenRepository();
  var accessTokenStore = AccessTokenStore(mockOAuthAuthenticator, mockAccessTokenRepository);

  group("addAccessToken", () {
    test(
      "generate, add and return an access token",
      () async {
        var generatedAccessToken = AccessToken('a', DateTime(2020), 'c', 'd', 'e');

        when(mockOAuthAuthenticator.authenticate()).thenAnswer(
          (_) async => generatedAccessToken,
        );

        await accessTokenStore.addAccessToken();

        expect(mockAccessTokenRepository.accessTokens.length, 1);
      },
    );

    test(
      "throw exception if unable to authenticate",
      () async {
        when(mockOAuthAuthenticator.authenticate()).thenThrow(Exception());

        expect(accessTokenStore.addAccessToken(), throwsException);
      },
    );
  });

  group("getAll", () {
    test(
      "gets all access tokens, one expired which needs refreshed and one not expired",
      () async {
		    var accessToken1 = AccessToken('a', DateTime.now(), 'c', 'd', 'e', 'uuid');
        var accessToken2 = AccessToken('f', DateTime.now().add(Duration(hours: 2)), 'g', 'h', 'i');
        var accessToken3 = AccessToken('a', DateTime.now().add(Duration(hours: 3)), 'c', 'd', 'e');

        when(mockOAuthAuthenticator.refresh(accessToken1.accessToken)).thenAnswer(
          (_) async => accessToken3,
        );

        mockAccessTokenRepository.insert(accessToken1);
        mockAccessTokenRepository.insert(accessToken2);

        var repoAccessTokens = await mockAccessTokenRepository.getAll();
        for (AccessToken accessToken in repoAccessTokens) {
	        if (accessToken.uuid == accessToken1)
	        {
            expect(accessToken.accessToken, accessToken3.accessToken);
            expect(accessToken.expiresAt, accessToken3.expiresAt);
            expect(accessToken.scope, accessToken3.scope);
            expect(accessToken.refreshToken, accessToken3.refreshToken);
            expect(accessToken.tokenType, accessToken3.tokenType);
          }
	        if (accessToken.uuid == accessToken2)
	        {
            expect(accessToken.accessToken, accessToken2.accessToken);
            expect(accessToken.expiresAt, accessToken2.expiresAt);
            expect(accessToken.scope, accessToken2.scope);
            expect(accessToken.refreshToken, accessToken2.refreshToken);
            expect(accessToken.tokenType, accessToken2.tokenType);
          }
        }
      },
    );

    test(
      "throw exception if unable to refresh",
      () async {
        when(mockOAuthAuthenticator.refresh(any)).thenThrow(Exception());

        //expect(accessTokenStore.getAll(), throwsException);
      },
    );
  });
}
*/
