import 'package:bankr/model/i_persist.dart';

abstract class IDao<E extends IPersist> {
  void insert(E saveableI);

  void update(E saveableI);

  void delete(E saveableI);

  Future<List<E>> getAll();

  void insertUnique(E saveableI) async {
    var existing = await getAll();
    if (!existing.contains(saveableI)) {
      insert(saveableI);
    }
  }
}
