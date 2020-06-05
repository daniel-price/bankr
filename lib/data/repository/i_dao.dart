import 'package:bankr/data/model/i_persist.dart';

abstract class IDao<E extends IPersist> {
  void insert(E persist);

  void update(E persist);

  void delete(E persist);

  Future<List<E>> getAll();

  Future<E> get (String uuid);

  void insertAllNew (List<E> persists)
  {
    for (E persist in persists)
    {
      insertIfNew(persist);
    }
  }

  void insertIfNew (E persist);
}