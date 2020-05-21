import 'dart:convert';

import 'package:bankr/auth/access_token.dart';
import 'package:bankr/auth/repository/i_access_token_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccessTokenRepositorySecureStorage extends IAccessTokenRepository {
  final FlutterSecureStorage _storage;
  final SharedPreferences _sharedPreferences;

  AccessTokenRepositorySecureStorage(this._storage, this._sharedPreferences);

  @override
  void delete(AccessToken accessToken) async {
    await _storage.delete(key: accessToken.key.toString());
  }

  @override
  Future<AccessToken> get(int keyAccessToken) async {
    var accessTokenString = await _storage.read(key: keyAccessToken.toString());
    return _readAccessToken(keyAccessToken.toString(), accessTokenString);
  }

  @override
  Future<List<AccessToken>> getAll() async {
    Map<String, String> accessTokenMaps = await _storage.readAll();

    List<AccessToken> accessTokens = new List();

    accessTokenMaps.forEach((key, value) {
      AccessToken accessToken = _readAccessToken(key, value);
      accessTokens.add(accessToken);
    });
    return accessTokens;
  }

  @override
  void insert(AccessToken accessToken) async {
    accessToken.key = await _generateKey();
    await _writeAccessToken(accessToken, accessToken.key);
  }

  @override
  void update(AccessToken accessToken) async {
    await delete(accessToken);
    await _writeAccessToken(accessToken, accessToken.key);
  }

  Future<int> _generateKey() async {
    int nextKey = (_sharedPreferences.getInt('LastKey') ?? 0) + 1;
    await _sharedPreferences.setInt('LastKey', nextKey);
    return nextKey;
  }

  void _writeAccessToken(AccessToken accessToken, int key) async {
    String value = _toPersistString(accessToken);
    await _storage.write(key: key.toString(), value: value);
  }

  AccessToken _readAccessToken(String key, String value) {
    AccessToken accessToken = _fromPersistString(value);
    accessToken.key = int.parse(key);
    return accessToken;
  }

  AccessToken _fromPersistString(String string) {
    Map<String, dynamic> map = json.decode(string) as Map<String, dynamic>;
    return AccessToken(
      map['accessToken'] as String,
      DateTime.fromMillisecondsSinceEpoch(map['expiresAt'] as int),
      map['tokenType'] as String,
      map['refreshToken'] as String,
      map['scope'] as String,
      map['id'] as int,
    );
  }

  String _toPersistString(AccessToken accessToken) {
    var map = <String, dynamic>{
      'id': accessToken.key,
      'accessToken': accessToken.accessToken,
      'expiresAt': accessToken.expiresAt.millisecondsSinceEpoch,
      'tokenType': accessToken.tokenType,
      'refreshToken': accessToken.refreshToken,
      'scope': accessToken.scope,
    };

    return json.encode(map);
  }
}
