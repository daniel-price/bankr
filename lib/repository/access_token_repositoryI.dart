import 'package:bankr/model/access_token.dart';

abstract class AccessTokenRepositoryI
{
  void insert (AccessToken accessToken);

  void update (AccessToken accessToken);

  void delete (AccessToken accessToken);
  Future<List<AccessToken>> getAccessTokens();
}
