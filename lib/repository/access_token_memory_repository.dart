import 'dart:collection';

import 'package:bankr/model/access_token.dart';
import 'package:bankr/repository/access_token_repositoryI.dart';


class AccessTokenMemoryRepository extends AccessTokenRepositoryI {
  final HashMap<int, AccessToken> accessTokens = new HashMap(); //TODO - persist

  @override
  insert(AccessToken accessToken) {
    var nextKey = getNextKey();
    accessToken.key = nextKey;
    accessTokens[nextKey] = accessToken;
    notifyListeners();
  }

  @override
  update(AccessToken accessToken) {
    accessTokens[accessToken.key] = accessToken;
  }

  @override
  delete(AccessToken accessToken) {
    accessTokens.remove(accessToken.key);
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
