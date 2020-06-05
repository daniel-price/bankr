import 'package:uuid/uuid.dart';

abstract class IPersist {
  String uuid;

  IPersist([
    String uuid,
  ]) : this.uuid = uuid ?? Uuid().v4();

  ApiReferenceData get apiReferenceData;
}

class ApiReferenceData {
  final String _name;
  final String _data;

  ApiReferenceData(this._name, this._data);

  String get name => _name;

  String get data => _data;
}