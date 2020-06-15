import 'package:uuid/uuid.dart';

abstract class IPersist {
  String uuid;

  IPersist([
    String uuid,
  ]) : this.uuid = uuid ?? Uuid().v4();

  ColumnNameAndData get apiReferenceData;
}

class ColumnNameAndData {
  final String _name;
  final Object _data;

  ColumnNameAndData(this._name, this._data);

  String get name => _name;

  Object get data
  => _data;
}