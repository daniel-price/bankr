import 'package:bankr/model/account.dart';
import 'package:bankr/model/account_transaction.dart';

abstract class IApiAdapter {
  Future<List<Account>> retrieveAccounts(String accessToken, int accessTokenId);

  Future<List<AccountTransaction>> retrieveTransactions(String accessToken, Account account);
}
