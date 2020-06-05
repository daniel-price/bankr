import 'package:bankr/api/i_api_adapter.dart';
import 'package:bankr/api/true_layer_api_adapter.dart';
import 'package:bankr/data/download/abstract_data_retriever.dart';
import 'package:bankr/data/download/download_parameters.dart';
import 'package:bankr/data/download/downloaded_data.dart';
import 'package:bankr/data/model/account.dart';
import 'package:bankr/data/model/account_balance.dart';
import 'package:bankr/data/model/account_transaction.dart';

class ProviderRetriever extends AbstractDataRetriever<AccountProvider> {
  ProviderRetriever(IApiAdapter apiAdapter) : super(apiAdapter);

  @override
  Future<AccountProvider> retrieve(DownloadParameters dataBuilder, DownloadedData downloadedData) async {
    return await apiAdapter.retrieveProvider(dataBuilder.uuidAccessToken);
  }

  @override
  void setData(DownloadedData downloadedData, AccountProvider data) {
    downloadedData.accountProvider = data;
  }

  @override
  bool shouldExecute(DownloadParameters dataBuilder) {
    return dataBuilder.firstRetrieve;
  }
}

class AccountsRetriever extends AbstractDataRetriever<List<Account>> {
  AccountsRetriever(IApiAdapter apiAdapter) : super(apiAdapter);

  @override
  Future<List<Account>> retrieve(DownloadParameters dataBuilder, DownloadedData downloadedData) async {
    return await apiAdapter.retrieveAccounts(dataBuilder.uuidAccessToken, downloadedData.accountProvider.uuid);
  }

  @override
  void setData(DownloadedData downloadedData, List<Account> data) {
    downloadedData.accounts = data;
  }

  @override
  bool shouldExecute(DownloadParameters dataBuilder) {
    return dataBuilder.firstRetrieve;
  }
}

class BalancesRetriever extends AbstractDataRetriever<List<AccountBalance>> {
  BalancesRetriever(IApiAdapter apiAdapter) : super(apiAdapter);

  @override
  Future<List<AccountBalance>> retrieve(DownloadParameters dataBuilder, DownloadedData downloadedData) async {
    List<AccountBalance> balances = List();
    for (Account account in downloadedData.accounts) {
      var accountBalance = await apiAdapter.retrieveBalance(dataBuilder.uuidAccessToken, account);
      if (accountBalance == null) {
        return null;
      }
      balances.add(accountBalance);
    }
    return balances;
  }

  @override
  void setData(DownloadedData downloadedData, List<AccountBalance> data) {
    downloadedData.accountBalances = data;
  }
}

class TransactionsRetriever extends AbstractDataRetriever<List<AccountTransaction>> {
  TransactionsRetriever(IApiAdapter apiAdapter) : super(apiAdapter);

  @override
  Future<List<AccountTransaction>> retrieve(DownloadParameters dataBuilder, DownloadedData downloadedData) async {
    DateRange dateRange = getProviderTransactionDateRange(dataBuilder, downloadedData);
    List<AccountTransaction> balances = List();
    for (Account account in downloadedData.accounts) {
      var accountBalance = await apiAdapter.retrieveTransactions(dataBuilder.uuidAccessToken, account, dateRange);
      if (accountBalance == null) {
        return null;
      }
      balances.addAll(accountBalance);
    }
    return balances;
  }

  DateRange getProviderTransactionDateRange(DownloadParameters dataBuilder, DownloadedData downloadedData) {
    if (!dataBuilder.firstRetrieve) {
      return null;
    }

    var provider = downloadedData.accountProvider;
    var now = DateTime.now();
    DateTime from = now.subtract(Duration(days: provider.dataAccessSavingsDays - 1));
    var to = now.subtract(Duration(hours: 6));
    return DateRange(from, to);
  }

  @override
  void setData(DownloadedData downloadedData, List<AccountTransaction> data) {
    downloadedData.accountTransactions = data;
  }
}
