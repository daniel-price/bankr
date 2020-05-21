import 'package:bankr/data/model/account_transaction.dart';
import 'package:bankr/data/repository/i_dao.dart';

class TransactionsScreenController {
  final IDao<AccountTransaction> accountTransactionDao;

  TransactionsScreenController(this.accountTransactionDao);

  Future<List<AccountTransaction>> getAllAccountsTransactions() {
    return accountTransactionDao.getAll();
  }
}
