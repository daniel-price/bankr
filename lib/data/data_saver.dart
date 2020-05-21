import 'package:bankr/data/model/account.dart';
import 'package:bankr/data/model/account_transaction.dart';
import 'package:bankr/data/model/i_persist.dart';
import 'package:bankr/data/repository/i_dao.dart';

class DataSaver {
  final IDao<Account> _accountDao;
  final IDao<AccountTransaction> _accountTransactionDao;

  DataSaver(this._accountDao, this._accountTransactionDao);

  void saveAccounts(List<Account> accounts) async {
    await _saveNewPersists(accounts, _accountDao);
  }

  void saveAccountTransactions(List<AccountTransaction> transactions) async {
    await _saveNewPersists(transactions, _accountTransactionDao);
  }

  void _saveNewPersists(List<IPersist> persists, IDao<IPersist> dao) async {
    var existing = await dao.getAll();
    for (IPersist persist in persists) {
      if (!existing.contains(persist)) {
        dao.insert(persist);
      }
    }
  }
}
