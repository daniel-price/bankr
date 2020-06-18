import 'package:bankr/data/model/i_persist.dart';

class Account extends IPersist {
  final String _updateTimestamp;
  final String _accountId;
  final String _accountType;
  final String _name;
  final String _currency;
  final String _iban;
  final String _swiftBic;
  final String _number;
  final String _sortCode;
  final String _uuidProvider;

  Account(this._updateTimestamp, this._accountId, this._accountType, this._name, this._currency, this._iban, this._swiftBic, this._number, this._sortCode, this._uuidProvider, [String uuid])
      : super(uuid) {
    assert(this._updateTimestamp != null);
    assert(this._accountId != null);
    assert(this._accountType != null);
    assert(this._name != null);
    assert(this._currency != null);
    assert(this._iban != null);
    assert(this._swiftBic != null);
    assert(this._number != null);
    assert(this._sortCode != null);
    assert(this._uuidProvider != null);
    assert(this.uuid != null);
  }

  String get updateTimestamp => _updateTimestamp;

  String get accountId => _accountId;

  String get accountType => _accountType;

  String get name => _name;

  String get currency => _currency;

  String get iban => _iban;

  String get swiftBic => _swiftBic;

  String get number => _number;

  String get sortCode => _sortCode;

  String get uuidProvider
  => _uuidProvider;

  @override
  ColumnNameAndData get apiReferenceData => ColumnNameAndData('accountId', accountId);
}
