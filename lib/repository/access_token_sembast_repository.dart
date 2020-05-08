import 'package:bankr/model/access_token.dart';
import 'package:bankr/repository/access_token_json_converter.dart';
import 'package:sembast/sembast.dart';

import 'access_token_repositoryI.dart';

class AccessTokenDatabaseRepository extends AccessTokenRepositoryI {
  final StoreRef _store;
  final Database _db;
  final AccessTokenJsonConverter _accessTokenJsonConverter;

  AccessTokenDatabaseRepository(
      this._store, this._db, this._accessTokenJsonConverter);

  @override
  void delete(AccessToken accessToken) async {
    final finder = Finder(filter: Filter.byKey(accessToken.id));
    await _store.delete(
      _db,
      finder: finder,
    );
  }

  @override
  Future<List<AccessToken>> getAccessTokens() async {
    final finder = Finder();

    final recordSnapshots = await _store.find(
      _db,
      finder: finder,
    );

    return recordSnapshots.map((snapshot) {
      final accessToken = _accessTokenJsonConverter
          .fromMap(snapshot.value as Map<String, dynamic>);
      accessToken.id = snapshot.key as int;
      return accessToken;
    }).toList();
  }

  @override
  insert(AccessToken accessToken) async {
    accessToken.id = await _store.add(
        _db, _accessTokenJsonConverter.toMap(accessToken)) as int;
  }

  @override
  update(AccessToken accessToken) async {
    final finder = Finder(filter: Filter.byKey(accessToken.id));
    await _store.update(
      _db,
      _accessTokenJsonConverter.toMap(accessToken),
      finder: finder,
    );
  }
}
