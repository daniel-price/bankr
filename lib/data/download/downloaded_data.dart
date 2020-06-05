import 'package:bankr/api/true_layer_api_adapter.dart';
import 'package:bankr/data/model/account.dart';
import 'package:bankr/data/model/account_balance.dart';
import 'package:bankr/data/model/account_transaction.dart';

class DownloadedData {
  AccountProvider _accountProvider;
  List<Account> _accounts;
  List<AccountBalance> _accountBalances;
  List<AccountTransaction> _accountTransactions;

  AccountProvider get accountProvider => _accountProvider;

  List<Account> get accounts => _accounts;

  List<AccountBalance> get accountBalances => _accountBalances;

  List<AccountTransaction> get accountTransactions => _accountTransactions;

  void set accountProvider(AccountProvider accountProvider) {
    if (_accountProvider != null) {
      throw Exception('AccountProvider already set.');
    }
    _accountProvider = accountProvider;
  }

  void set accounts(List<Account> accounts) {
    if (_accounts != null) {
      throw Exception('accounts already set.');
    }
    _accounts = accounts;
  }

  void set accountBalances(List<AccountBalance> accountBalances) {
    if (_accountBalances != null) {
      throw Exception('accountBalances already set.');
    }
    _accountBalances = accountBalances;
  }

  void set accountTransactions(List<AccountTransaction> accountTransactions) {
    if (_accountTransactions != null) {
      throw Exception('accountTransactions already set.');
    }
    _accountTransactions = accountTransactions;
  }
}
