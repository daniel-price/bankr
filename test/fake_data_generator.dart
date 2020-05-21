import 'package:bankr/data/model/account.dart';
import 'package:bankr/data/model/account_transaction.dart';

Account generateFakeAccount(String accountId) {
  return Account("updateTimestamp", accountId, "accountType", "name", "currency", "iban", "swiftBic", "number", "sortCode", "providerName", "providerId", "logoUri", 2, 3);
}

AccountTransaction generateFakeAccountTransaction(String transactionId) {
  return AccountTransaction('timestamp', 'description', 'transactionType', 'transactionCategory', 100, 'currency', transactionId, 4, 3);
}

List<AccountTransaction> generateFakeAccountTransactions(String transactionIdSuffix) {
  var accountTransactions = List<AccountTransaction>();
  accountTransactions.add(generateFakeAccountTransaction("1$transactionIdSuffix"));
  accountTransactions.add(generateFakeAccountTransaction("2$transactionIdSuffix"));
  return accountTransactions;
}

List<Account> generateFakeAccounts(String accountIdSuffix) {
  var accounts = List<Account>();
  accounts.add(generateFakeAccount("1$accountIdSuffix"));
  accounts.add(generateFakeAccount("2$accountIdSuffix"));
  accounts.add(generateFakeAccount("3$accountIdSuffix"));
  accounts.add(generateFakeAccount("4$accountIdSuffix"));
  return accounts;
}
