import 'package:bankr/data/model/account.dart';
import 'package:bankr/data/model/account_balance.dart';
import 'package:bankr/screen/accounts/provider_info.dart';

class AccountInfo {
  final Account _account;

  Account get account => _account;

  final AccountBalance _accountBalance;

  AccountInfo(this._account, this._accountBalance);

  AccountBalance get accountBalance => _accountBalance;

  String get accountBalanceDesc => getBalanceDesc(accountBalance.current);

  String get accountName => _account.name;

  String get currentAccountBalance => _accountBalance.current.toString();

  String get number => _account.number;

  String get sortCode => _account.sortCode;

  String get accountType => _account.accountType;
}
