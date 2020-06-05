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
      : super(uuid);

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
  bool sameAs (IPersist other)
  {
    return other is AccountTransaction && other._transactionId == _transactionId;
  }
}
