import 'dart:collection';

import 'package:bankr/model/access_token.dart';
import 'package:bankr/repository/access_token_repositoryI.dart';

class AccessTokenMemoryRepository extends AccessTokenRepositoryI {
  final HashMap<int, AccessToken> accessTokens = HashMap();

  @override
  void insert (AccessToken accessToken)
  {
    var nextKey = getNextKey();
    accessToken.id = nextKey;
    accessTokens[nextKey] = accessToken;
  }

  @override
  void update (AccessToken accessToken)
  {
    accessTokens[accessToken.id] = accessToken;
  }

  @override
  delete(AccessToken accessToken) {
    accessTokens.remove(accessToken.id);
  }

  @override
  Future<List<AccessToken>> getAccessTokens() {
    return Future.value(accessTokens.values.toList());
  }

  int getNextKey() {
    var largestKey = getLargestKey();
    return largestKey + 1;
  }

  int getLargestKey() {
    Iterable<int> keys = accessTokens.keys;
    int largestKey = 0;
    for (int key in keys) {
      if (key > largestKey) {
        largestKey = key;
      }
    }
    return largestKey;
  }
}
