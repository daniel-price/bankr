import 'package:bankr/auth/access_token.dart';
import 'package:bankr/auth/oauth/o_auth_authenticator.dart';
import 'package:bankr/auth/repository/i_access_token_repository.dart';

class AccessTokenStore {
  final OAuthAuthenticator _oAuthAuthenticator;
  final IAccessTokenRepository _accessTokenRepository;

  AccessTokenStore(this._oAuthAuthenticator, this._accessTokenRepository);

  Future<int> addAccessToken() async {
    AccessToken accessToken = await _oAuthAuthenticator.authenticate();
    if (accessToken == null) {
      return null;
    }
    await _accessTokenRepository.insert(accessToken);
    return accessToken.key;
  }

  Future<AccessToken> _ensureRefreshed(AccessToken accessToken) async {
    if (!accessToken.shouldRefresh)
    {
      return accessToken;
    }

    var refreshedAccessToken = await _oAuthAuthenticator.refresh(accessToken.refreshToken);
    refreshedAccessToken.key = accessToken.key;

    await _accessTokenRepository.update(accessToken);
    return refreshedAccessToken;
  }

  Future<String> getToken (int keyAccessToken)
  async {
    AccessToken accessToken = await _accessTokenRepository.get(keyAccessToken);
    await _ensureRefreshed(accessToken);
    return accessToken.accessToken;
  }
}
