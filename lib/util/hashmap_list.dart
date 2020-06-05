import 'dart:collection';

class HashMapList<K, V> {
  final HashMap<K, List<V>> _listByKey = HashMap();

  HashMapList();

  void add(K key, V value) {
    var list = getList(key);
    list.add(value);
  }

  List<V> getList(K key) {
    if (!_listByKey.containsKey(key)) {
      _listByKey[key] = List();
    }
    return _listByKey[key];
  }

  void forEach(void f(K key, List<V> value)) {
    _listByKey.forEach((key, value) {
      f(key, value);
    });
  }
}
