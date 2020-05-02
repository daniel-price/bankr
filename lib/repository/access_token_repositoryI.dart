

import 'package:bankr/model/access_token.dart';

abstract class AccessTokenRepositoryI {
  insert(AccessToken accessToken);
  update(AccessToken accessToken);
  delete(AccessToken accessToken);
  Future<List<AccessToken>> getAccessTokens();
}
