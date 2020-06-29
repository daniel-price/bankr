import 'dart:collection';

import 'package:bankr/data/dao/i_dao.dart';
import 'package:bankr/data/model/account.dart';
import 'package:bankr/data/model/account_provider.dart';
import 'package:bankr/data/model/account_transaction.dart';
import 'package:intl/intl.dart';

class DateTransactionsInfoRepository {
  final IDao<AccountTransaction> accountTransactionDao;
  final IDao<Account> accountDao;
	final IDao<AccountProvider> _accountProviderDao;

  List<DateTransactionsInfo> cachedDateTransactionRows;

  DateTransactionsInfoRepository(this.accountTransactionDao, this.accountDao, this._accountProviderDao);

  invalidateCache ()
	{
		cachedDateTransactionRows = null;
	}

  Future<List<DateTransactionsInfo>> getAllAccountsTransactions() async {
		if (cachedDateTransactionRows == null)
		{
			cachedDateTransactionRows = await generateDateTransactionRows();
		}
		return cachedDateTransactionRows;
	}

  Future<List<DateTransactionsInfo>> generateDateTransactionRows ()
	async {
    var accountTransactions = await accountTransactionDao.getAll();
    var dateTransactionRowsbyDate = HashMap<DateTime, DateTransactionsInfo>();
    for (AccountTransaction accountTransaction in accountTransactions) {
      var date = accountTransaction.date;
      var dateTransactionRow = dateTransactionRowsbyDate[date];
      if (dateTransactionRow == null)
      {
	      dateTransactionRow = DateTransactionsInfo(date);
	      dateTransactionRowsbyDate[date] = dateTransactionRow;
      }
      var account = await accountDao.get(accountTransaction.uuidAccount);
      var accountProvider = await _accountProviderDao.get(account.uuidProvider);
      var accountTransactionRow = AccountTransactionRow(accountTransaction, accountProvider);
      dateTransactionRow.add(accountTransactionRow);
    }
    var list = dateTransactionRowsbyDate.values.toList();
    list.sort();
    return list;
  }
}

class DateTransactionsInfo
		implements Comparable<DateTransactionsInfo>
{
  final DateTime _date;
  final List<AccountTransactionRow> accountTransactions = List();

  DateTransactionsInfo (this._date);

  String get formattedDate {
    var formatter = new DateFormat('MMMEd');
    return formatter.format(_date);
  }

  DateTime get date => _date;

  void add (AccountTransactionRow accountTransactionRow)
  {
	  accountTransactions.add(accountTransactionRow);
  }

  @override
  int compareTo (DateTransactionsInfo other)
  {
    return other.date.compareTo(date);
  }
}

class AccountTransactionRow
{
	final AccountTransaction _accountTransaction;
	final AccountProvider _accountProvider;

	AccountTransactionRow (this._accountTransaction, this._accountProvider);

	String get description
	=> _accountTransaction.description;

	get amount
	=> _accountTransaction.amount;

	AccountProvider get accountProvider
	=> _accountProvider;
}
