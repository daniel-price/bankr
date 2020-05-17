import 'package:bankr/auth/o_auth_director.dart';
import 'package:bankr/model/access_token_model.dart';
import 'package:bankr/repository/i_dao.dart';

class AccessTokenStore {
  final OAuthDirector _oauthAuthenticator;
  final IDao<AccessToken> _accessTokenModelDao;

  AccessTokenStore(this._oauthAuthenticator, this._accessTokenModelDao);

  Future<AccessToken> _ensureRefreshed(AccessToken accessToken) async {
    if (accessToken.shouldRefresh) {
      accessToken = await _oauthAuthenticator.refresh(accessToken.refreshToken);
      await _accessTokenModelDao.update(accessToken);
    }
    return accessToken;
  }

  Future<AccessToken> addAccessToken() async {
    AccessToken accessToken = await _oauthAuthenticator.authenticate();
    _accessTokenModelDao.insert(accessToken);
    return accessToken;
  }

  Future<List<AccessToken>> getAll() async {
    List<AccessToken> refreshedAccessTokens = List<AccessToken>();
    for (AccessToken accessToken in await _accessTokenModelDao.getAll()) {
      refreshedAccessTokens.add(await _ensureRefreshed(accessToken));
    }
    return refreshedAccessTokens;
  }
}
