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
  final String _providerName;
  final String _providerId;
  final String _logoUri;
  final int _keyAccessToken;

  Account(this._updateTimestamp, this._accountId, this._accountType, this._name, this._currency, this._iban, this._swiftBic, this._number, this._sortCode, this._providerName, this._providerId,
      this._logoUri, this._keyAccessToken,
      [int id])
      : super(id);

  String get updateTimestamp => _updateTimestamp;

  String get accountId => _accountId;

  String get accountType => _accountType;

  String get name => _name;

  String get currency => _currency;

  String get iban => _iban;

  String get swiftBic => _swiftBic;

  String get number => _number;

  String get sortCode => _sortCode;

  String get providerName => _providerName;

  String get providerId => _providerId;

  String get logoUri => _logoUri;

  int get keyAccessToken => _keyAccessToken;

  @override
  bool operator ==(dynamic other) {
    return other is Account && other._accountId == _accountId;
  }
}
