import 'package:bankr/model/i_persist.dart';

class AccountTransaction extends IPersist {
  final String _timestamp;
  final String _description;
  final String _transactionType;
  final String _transactionCategory;
  final double _amount;
  final String _currency;
  final String _transactionId;
  final int _keyAccount;

  AccountTransaction(this._timestamp, this._description, this._transactionType, this._transactionCategory, this._amount, this._currency, this._transactionId, this._keyAccount, [int id]) : super(id);

  String get timestamp => _timestamp;

  String get description => _description;

  String get transactionType => _transactionType;

  String get transactionCategory => _transactionCategory;

  double get amount => _amount;

  String get currency => _currency;

  String get transactionId => _transactionId;

  int get idAccount => _keyAccount;

  String get date => DateTime.parse(_timestamp).toString();

  @override
  bool operator ==(dynamic other) {
    return other is AccountTransaction && other._transactionId == _transactionId;
  }
}
