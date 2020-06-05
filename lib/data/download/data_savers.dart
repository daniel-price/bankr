import 'package:bankr/api/true_layer_api_adapter.dart';
import 'package:bankr/data/download/abstract_data_saver.dart';
import 'package:bankr/data/download/download_parameters.dart';
import 'package:bankr/data/download/downloaded_data.dart';
import 'package:bankr/data/model/account.dart';
import 'package:bankr/data/model/account_balance.dart';
import 'package:bankr/data/model/account_transaction.dart';
import 'package:bankr/data/repository/i_dao.dart';

class AccountProviderSaver extends AbstractDataSaver<AccountProvider> {
  AccountProviderSaver(IDao<AccountProvider> dao) : super(dao);

  @override
  List<AccountProvider> getDataList(DownloadedData downloadedData) {
    List<AccountProvider> list = List<AccountProvider>();
    list.add(downloadedData.accountProvider);
    return list;
  }

  bool shouldExecute(DownloadParameters dataBuilder) {
    return dataBuilder.firstRetrieve;
  }
}

class AccountsSaver extends AbstractDataSaver<Account> {
  AccountsSaver(IDao<Account> dao) : super(dao);

  @override
  List<Account> getDataList(DownloadedData downloadedData) {
    return downloadedData.accounts;
  }

  bool shouldExecute(DownloadParameters dataBuilder) {
    return dataBuilder.firstRetrieve;
  }
}

class AccountBalancesSaver extends AbstractDataSaver<AccountBalance> {
  AccountBalancesSaver(IDao<AccountBalance> dao) : super(dao);

  @override
  List<AccountBalance> getDataList(DownloadedData downloadedData) {
    return downloadedData.accountBalances;
  }
}

class AccountTransactionsSaver extends AbstractDataSaver<AccountTransaction> {
  AccountTransactionsSaver(IDao<AccountTransaction> dao) : super(dao);

  @override
  List<AccountTransaction> getDataList(DownloadedData downloadedData) {
    return downloadedData.accountTransactions;
  }
}
