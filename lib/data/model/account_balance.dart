import 'package:bankr/data/model/i_persist.dart';

class AccountBalance extends IPersist {
  final String _currency;
  final double _available;
  final double _current;
  final double _overdraft;
  final String _updateTimestamp;
  final String _uuidAccount;

  AccountBalance(this._currency, this._available, this._current, this._overdraft, this._updateTimestamp, this._uuidAccount, [String uuid]) : super(uuid);

  String get currency => _currency;

  double get available => _available;

  double get current => _current;

  double get overdraft => _overdraft;

  String get updateTimestamp => _updateTimestamp;

  String get uuidAccount => _uuidAccount;

  DateTime get updated => DateTime.parse(updateTimestamp);

  @override
  bool sameAs(IPersist existing) {
    return false;
  }
}
