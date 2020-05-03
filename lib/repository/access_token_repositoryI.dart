import 'package:bankr/model/access_token.dart';
import 'package:flutter/material.dart';

abstract class AccessTokenRepositoryI with ChangeNotifier {
  insert(AccessToken accessToken);
  update(AccessToken accessToken);
  delete(AccessToken accessToken);
  Future<List<AccessToken>> getAccessTokens();
}
