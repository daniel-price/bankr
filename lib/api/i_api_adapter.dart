import 'package:bankr/data/model/account.dart';
import 'package:bankr/data/model/account_transaction.dart';

abstract class IApiAdapter {
  Future<List<Account>> retrieveAccounts(int keyAccessToken);

  Future<List<AccountTransaction>> retrieveTransactions(int keyAccessToken, Account account);
}
