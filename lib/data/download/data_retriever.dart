import 'package:bankr/api/i_api_adapter.dart';
import 'package:bankr/data/download/downloaded_data.dart';
import 'package:bankr/data/model/account.dart';
import 'package:bankr/data/model/account_balance.dart';
import 'package:bankr/data/model/account_provider.dart';
import 'package:bankr/data/model/account_transaction.dart';
import 'package:bankr/util/date_range.dart';

class DataRetriever {
  final IApiAdapter _apiAdapter;

  DataRetriever(this._apiAdapter);

  Future<DownloadedData> retrieveAllData(String uuidAccessToken) async {
    var accountProvider = await _apiAdapter.retrieveAccountProvider(uuidAccessToken);
    if (accountProvider == null) {
      return null;
    }

    var accounts = await _apiAdapter.retrieveAccounts(uuidAccessToken, accountProvider.uuid);
    if (accounts == null) {
      return null;
    }

    return await retrieveBalancesAndTransactions(accountProvider, accounts);
  }

  Future<DownloadedData> retrieveBalancesAndTransactions(AccountProvider accountProvider, List<Account> accounts) async {
    var accountBalances = await _retrieveAccountBalances(accountProvider.uuidAccessToken, accounts);
    if (accountBalances == null) {
      return null;
    }

    var accountTransactions = await _retrieveAccountTransactions(accountProvider.uuidAccessToken, accounts, accountProvider);
    if (accountTransactions == null) {
      return null;
    }

    return DownloadedData(accountProvider, accounts, accountBalances, accountTransactions);
  }

  Future<List<AccountBalance>> _retrieveAccountBalances(String uuidAccessToken, List<Account> accounts) async {
    List<AccountBalance> accountBalances = List();
    for (Account account in accounts) {
      var accountBalance = await _apiAdapter.retrieveBalance(uuidAccessToken, account);
      if (accountBalance == null) {
        return null;
      }
      accountBalances.add(accountBalance);
    }

    return accountBalances;
  }

  Future<List<AccountTransaction>> _retrieveAccountTransactions(String uuidAccessToken, List<Account> accounts, AccountProvider accountProvider) async {
    DateRange dateRange = _getProviderTransactionDateRange(accountProvider);
    List<AccountTransaction> allAccountTransactions = List();
    for (Account account in accounts) {
      var accountTransactions = await _apiAdapter.retrieveTransactions(uuidAccessToken, account, dateRange);
      if (accountTransactions == null) {
        return null;
      }
      allAccountTransactions.addAll(accountTransactions);
    }
    return allAccountTransactions;
  }

  DateRange _getProviderTransactionDateRange(AccountProvider accountProvider) {
    if (accountProvider == null) {
      return null;
    }

    var now = DateTime.now();
    DateTime from = now.subtract(Duration(days: accountProvider.dataAccessSavingsDays - 1));
    var to = now.subtract(Duration(hours: 6));
    return DateRange(from, to);
  }
}
