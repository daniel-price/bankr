import 'package:bankr/data/model/account.dart';
import 'package:bankr/data/model/account_balance.dart';
import 'package:bankr/data/model/account_transaction.dart';
import 'package:bankr/data/model/i_persist.dart';
import 'package:bankr/data/repository/i_dao.dart';

class DataSaver {
  final IDao<Account> _accountDao;
  final IDao<AccountBalance> _accountBalanceDao;
  final IDao<AccountTransaction> _accountTransactionDao;

  DataSaver(this._accountDao, this._accountTransactionDao, this._accountBalanceDao);

  void saveAccounts(List<Account> accounts) async {
    await _saveNewPersists(accounts, _accountDao);
  }

  void saveAccountTransactions(List<AccountTransaction> transactions) async {
    await _saveNewPersists(transactions, _accountTransactionDao);
  }

  void _saveNewPersists<T extends IPersist> (List<T> persists, IDao<T> dao)
  async {
	  var allExisting = await dao.getAll();
	  for (T persist in persists)
	  {
		  T existing = _findInExisting(persist, allExisting);
		  if (existing == null)
		  {
			  await dao.insert(persist);
		  }
	  }
  }

  void saveAccountBalances (List<AccountBalance> accountBalances)
  async {
	  await _saveNewPersists(accountBalances, _accountBalanceDao);
  }

  T _findInExisting<T extends IPersist> (T persist, List<T> allExisting)
  {
	  for (T existing in allExisting)
	  {
		  if (persist.sameAs(existing))
		  {
			  return existing;
		  }
	  }
	  return null;
  }
}
