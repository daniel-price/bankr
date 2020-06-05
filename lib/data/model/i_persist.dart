import 'package:uuid/uuid.dart';

abstract class IPersist {
  String uuid;

  IPersist([
    String uuid,
  ]) : this.uuid = uuid ?? Uuid().v4();

  bool sameAs(IPersist existing);
}
