import 'dart:convert';

import 'package:bankr/auth/access_token.dart';
import 'package:bankr/auth/repository/i_access_token_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AccessTokenRepositorySecureStorage extends IAccessTokenRepository {
  final FlutterSecureStorage _storage;

  AccessTokenRepositorySecureStorage(this._storage);

  @override
  void delete(AccessToken accessToken) async {
	  await _storage.delete(key: accessToken.uuid);
  }

  @override
  Future<AccessToken> get (String uuidAccessToken)
  async {
	  var accessTokenString = await _storage.read(key: uuidAccessToken);
	  return _readAccessToken(uuidAccessToken, accessTokenString);
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
	  await _writeAccessToken(accessToken, accessToken.uuid);
  }

  @override
  void update(AccessToken accessToken) async {
    await delete(accessToken);
    await _writeAccessToken(accessToken, accessToken.uuid);
  }

  void _writeAccessToken (AccessToken accessToken, String uuid)
  async {
    String value = _toPersistString(accessToken);
    await _storage.write(key: uuid, value: value);
  }

  AccessToken _readAccessToken (String uuid, String value)
  {
    AccessToken accessToken = _fromPersistString(value);
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
	    map['uuid'] as String,
    );
  }

  String _toPersistString(AccessToken accessToken) {
    var map = <String, dynamic>{
	    'uuid': accessToken.uuid,
      'accessToken': accessToken.accessToken,
      'expiresAt': accessToken.expiresAt.millisecondsSinceEpoch,
      'tokenType': accessToken.tokenType,
      'refreshToken': accessToken.refreshToken,
      'scope': accessToken.scope,
    };

    return json.encode(map);
  }
}
