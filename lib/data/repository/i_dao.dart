import 'package:bankr/data/model/i_persist.dart';

abstract class IDao<E extends IPersist> {
  void insert(E saveableI);

  void update(E saveableI);

  void delete(E saveableI);

  Future<List<E>> getAll();
}
