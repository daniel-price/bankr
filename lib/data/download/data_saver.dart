import 'package:bankr/data/download/downloaded_data.dart';
import 'package:bankr/data/model/account.dart';
import 'package:bankr/data/model/account_balance.dart';
import 'package:bankr/data/model/account_provider.dart';
import 'package:bankr/data/model/account_transaction.dart';
import 'package:bankr/data/repository/i_dao.dart';

class DataSaver {
  final IDao<AccountProvider> _accountProviderDao;
  final IDao<Account> _accountDao;
  final IDao<AccountBalance> _accountBalanceDao;
  final IDao<AccountTransaction> _accountTransactionDao;

  DataSaver(this._accountProviderDao, this._accountDao, this._accountBalanceDao, this._accountTransactionDao);

  Future<void> save(DownloadedData downloadedData) async {
    await _accountProviderDao.insertIfNew(downloadedData.accountProvider);
    await _accountDao.insertAllNew(downloadedData.accounts);
    await _accountBalanceDao.insertAllNew(downloadedData.accountBalances);
    await _accountTransactionDao.insertAllNew(downloadedData.accountTransactions);
  }
}
