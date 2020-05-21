import 'package:bankr/api/i_api_adapter.dart';
import 'package:bankr/data/data_saver.dart';
import 'package:bankr/data/model/account.dart';
import 'package:bankr/data/model/account_transaction.dart';

class DataDownloader {
  final DataSaver _dataSaver;
  final IApiAdapter _apiAdapter;

  DataDownloader(this._apiAdapter, this._dataSaver);

  Future<bool> downloadData(int keyAccessToken) async {
    List<Account> accounts = await _apiAdapter.retrieveAccounts(keyAccessToken);
    if (accounts == null) {
      return false;
    }
    List<AccountTransaction> transactions = await _retrieveTransactions(keyAccessToken, accounts);
    if (transactions == null) {
      return false;
    }

    await _dataSaver.saveAccounts(accounts);
    await _dataSaver.saveAccountTransactions(transactions);
    return true;
  }

  Future<List<AccountTransaction>> _retrieveTransactions(int keyAccessToken, List<Account> accounts) async {
    List<AccountTransaction> allTransactions = List();
    for (Account account in accounts) {
      List<AccountTransaction> transactions = await _apiAdapter.retrieveTransactions(keyAccessToken, account);
      if (transactions == null) {
        return null;
      }

      allTransactions.addAll(transactions);
    }
    return allTransactions;
  }
}
