import 'package:bankr/auth/access_token.dart';

abstract class IAccessTokenRepository {
  void insert(AccessToken accessToken);

  void update(AccessToken accessToken);

  void delete(AccessToken accessToken);

  Future<List<AccessToken>> getAll();

  Future<AccessToken> get(int keyAccessToken);
}
