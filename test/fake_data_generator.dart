import 'dart:math';

import 'package:bankr/data/download/downloaded_data.dart';
import 'package:bankr/data/model/account.dart';
import 'package:bankr/data/model/account_balance.dart';
import 'package:bankr/data/model/account_provider.dart';
import 'package:bankr/data/model/account_transaction.dart';
import 'package:uuid/uuid.dart';

Account generateFakeAccount(String accountId) {
  return Account(
    "updateTimestamp",
    accountId,
    "accountType",
    "name",
    "currency",
    "iban",
    "swiftBic",
    "number",
    "sortCode",
    randomUuid(),
    randomUuid(),
  );
}

AccountTransaction generateFakeAccountTransaction(String transactionId) {
  return AccountTransaction(
    'timestamp',
    'description',
    'transactionType',
    'transactionCategory',
    randomDouble(),
    'currency',
    transactionId,
    'Merchant Name',
    randomUuid(),
    randomUuid(),
  );
}

AccountBalance generateFakeAccountBalance() {
  return AccountBalance(
    'GBP',
    randomDouble(),
    randomDouble(),
    randomDouble(),
    'timestamp',
    randomUuid(),
    randomUuid(),
  );
}

AccountProvider generateFakeAccountProvider() {
  return AccountProvider(
    "displayName",
    "logoUri",
    "providerId",
    randomInt(),
    randomInt(),
    randomBool(),
    "logoSvg",
    randomUuid(),
    randomUuid(),
  );
}

int randomInt({int max = 10000}) => new Random().nextInt(max);

double randomDouble({double max = 10000}) => new Random().nextDouble() * max;

String randomUuid() => Uuid().v4();

bool randomBool() => new Random().nextBool();

List<AccountTransaction> generateFakeAccountTransactions({String transactionIdSuffix}) {
  var accountTransactions = List<AccountTransaction>();
  accountTransactions.add(generateFakeAccountTransaction("1$transactionIdSuffix"));
  accountTransactions.add(generateFakeAccountTransaction("2$transactionIdSuffix"));
  return accountTransactions;
}

List<Account> generateFakeAccounts ({String accountIdSuffix})
{
  var accounts = List<Account>();
  accounts.add(generateFakeAccount("1$accountIdSuffix"));
  accounts.add(generateFakeAccount("2$accountIdSuffix"));
  accounts.add(generateFakeAccount("3$accountIdSuffix"));
  accounts.add(generateFakeAccount("4$accountIdSuffix"));
  return accounts;
}

List<AccountBalance> generateFakeAccountBalances ()
{
  var accountBalance = List<AccountBalance>();
  accountBalance.add(generateFakeAccountBalance());
  accountBalance.add(generateFakeAccountBalance());
  return accountBalance;
}

DownloadedData generateFakeDownloadedData ()
{
  var accountProvider = generateFakeAccountProvider();
  var accounts = generateFakeAccounts();
  var accountBalances = generateFakeAccountBalances();
  var accountTransactions = generateFakeAccountTransactions();
  return DownloadedData(accountProvider, accounts, accountBalances, accountTransactions);
}