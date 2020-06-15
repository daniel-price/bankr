import 'package:bankr/data/model/i_persist.dart';

class AccountProviderUpdateAudit extends IPersist {
  final String _uuidAccountProvider;
  final String _updateTimestamp;
  final bool _success;

  AccountProviderUpdateAudit(this._uuidAccountProvider, this._updateTimestamp, this._success, [String uuid]) : super(uuid);

  factory AccountProviderUpdateAudit.factory(String uuidAccountProvider, DateTime updatedTime, bool success, [String uuid]) {
    var updateTimestamp = updatedTime.toIso8601String();
    return AccountProviderUpdateAudit(uuidAccountProvider, updateTimestamp, success, uuid);
  }

  @override
  ColumnNameAndData get apiReferenceData => null;

  bool get success => _success;

  String get updateTimestamp => _updateTimestamp;

  DateTime get updatedTime => DateTime.parse(_updateTimestamp);

  String get accountProviderUuid => _uuidAccountProvider;
}
