import 'package:bankr/auth/access_token.dart';
import 'package:bankr/auth/oauth/o_auth_authenticator.dart';
import 'package:bankr/auth/repository/i_access_token_repository.dart';

class AccessTokenStore {
  final OAuthAuthenticator _oAuthAuthenticator;
  final IAccessTokenRepository _accessTokenRepository;

  AccessTokenStore(this._oAuthAuthenticator, this._accessTokenRepository);

  Future<String> addAccessToken() async {
    AccessToken accessToken = await _oAuthAuthenticator.authenticate();
    if (accessToken == null) {
      return null;
    }
    await _accessTokenRepository.insert(accessToken);
    return accessToken.uuid;
  }

  Future<AccessToken> _ensureRefreshed(AccessToken accessToken) async {
    if (!accessToken.shouldRefresh)
    {
      return accessToken;
    }

    var refreshedAccessToken = await _oAuthAuthenticator.refresh(accessToken.refreshToken);
    refreshedAccessToken.uuid = accessToken.uuid;

    await _accessTokenRepository.update(refreshedAccessToken);
    return refreshedAccessToken;
  }

  Future<String> getToken (String uuidAccessToken)
  async {
    AccessToken accessToken = await _accessTokenRepository.get(uuidAccessToken);
    await _ensureRefreshed(accessToken);
    return accessToken.accessToken;
  }

  Future<List<String>> getAllKeys ()
  async {
    List<AccessToken> accessTokens = await _accessTokenRepository.getAll();
    List<String> uuidAccessTokens = List();
    for (AccessToken accessToken in accessTokens)
    {
      uuidAccessTokens.add(accessToken.uuid);
    }
    return uuidAccessTokens;
  }
}
