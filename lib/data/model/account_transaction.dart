import 'package:bankr/data/model/i_persist.dart';

class AccountTransaction extends IPersist {
  final String _timestamp;
  final String _description;
  final String _transactionType;
  final String _transactionCategory;
  final double _amount;
  final String _currency;
  final String _transactionId;
  final String _merchantName;
  final String _uuidAccount;

  AccountTransaction(this._timestamp, this._description, this._transactionType, this._transactionCategory, this._amount, this._currency, this._transactionId, this._merchantName, this._uuidAccount,
      [String uuid])
      : super(uuid) {
    assert(this._timestamp != null);
    assert(this._description != null);
    assert(this._transactionType != null);
    assert(this._transactionCategory != null);
    assert(this._amount != null);
    assert(this._currency != null);
    assert(this._transactionId != null);
    assert(this._merchantName != null);
    assert(this._uuidAccount != null);
    assert(this.uuid != null);
  }

  String get timestamp => _timestamp;

  String get description => _description;

  String get transactionType => _transactionType;

  String get transactionCategory => _transactionCategory;

  double get amount => _amount;

  String get currency => _currency;

  String get transactionId => _transactionId;

  String get uuidAccount
  => _uuidAccount;

  DateTime get dateTime
  {
	  return DateTime.parse(_timestamp);
  }

  DateTime get date
  {
	  return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  String get merchantName
  => _merchantName;

  @override
  ColumnNameAndData get apiReferenceData => ColumnNameAndData('transactionId', transactionId);
}
