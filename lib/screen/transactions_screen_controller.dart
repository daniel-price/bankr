import 'dart:collection';

import 'package:bankr/data/model/account.dart';
import 'package:bankr/data/model/account_transaction.dart';
import 'package:bankr/data/repository/i_dao.dart';
import 'package:intl/intl.dart';

class TransactionsScreenController {
	final IDao<AccountTransaction> accountTransactionDao;
  final IDao<Account> accountDao;

  TransactionsScreenController(this.accountTransactionDao, this.accountDao);

  Future<List<AccountTransactionRow>> getAllAccountsTransactions() async {
    var accountTransactions = await accountTransactionDao.getAll();
    var accountTransactionRowsbyDate = HashMap<DateTime, AccountTransactionRow>();
    for (AccountTransaction accountTransaction in accountTransactions) {
      var date = accountTransaction.date;
      var accountTransactionRow = accountTransactionRowsbyDate[date];
      if (accountTransactionRow == null) {
        accountTransactionRow = AccountTransactionRow(date);
        accountTransactionRowsbyDate[date] = accountTransactionRow;
      }
      accountTransactionRow.add(accountTransaction);
    }
    var list = accountTransactionRowsbyDate.values.toList();
    list.sort();
    return list;
  }

  void testMethod() async {
    var dao = accountTransactionDao;
    var allElements = await dao.getAll();
    print(allElements.length);
  }
}

class AccountTransactionRow implements Comparable<AccountTransactionRow> {
  final DateTime _date;
  final List<AccountTransaction> accountTransactions = List();

  AccountTransactionRow(this._date);

  String get formattedDate {
    var formatter = new DateFormat('MMMEd');
    return formatter.format(_date);
  }

  DateTime get date => _date;

  void add(AccountTransaction accountTransaction) {
    accountTransactions.add(accountTransaction);
  }

  @override
  int compareTo(AccountTransactionRow other) {
    return other.date.compareTo(date);
  }
}