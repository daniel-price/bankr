import 'package:bankr/data/model/account.dart';
import 'package:bankr/data/model/account_balance.dart';
import 'package:bankr/data/model/account_provider.dart';
import 'package:bankr/data/model/account_transaction.dart';
import 'package:bankr/util/date_range.dart';

abstract class IApiAdapter {
  Future<List<Account>> retrieveAccounts(String uuidAccessToken, String uuidProvider);

  Future<List<AccountTransaction>> retrieveTransactions(String uuidAccessToken, Account account, [DateRange dateRange]);

  Future<AccountBalance> retrieveBalance(String uuidAccessToken, Account account);

  Future<AccountProvider> retrieveAccountProvider(String uuidAccessToken);
}
