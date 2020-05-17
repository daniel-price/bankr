import 'dart:io';

import 'package:bankr/api/i_api_adapter.dart';
import 'package:bankr/model/account.dart';
import 'package:bankr/model/account_transaction.dart';
import 'package:bankr/util/http.dart';

class TrueLayerApiAdapter extends IApiAdapter {
  final Http http;

  TrueLayerApiAdapter(this.http);

  @override
  Future<List<Account>> retrieveAccounts(String accessToken, int keyAccessToken) async {
    List<Map<String, dynamic>> results = await _getResultsFromTL("https://api.truelayer.com/data/v1/accounts", {HttpHeaders.authorizationHeader: "Bearer " + accessToken});

    List<Account> accounts = new List();
    for (int i = 0; i < results.length; i++) {
      Map<String, dynamic> result = results[i];
      Account account = _accountFromResult(result, keyAccessToken);
      accounts.add(account);
    }

    return accounts;
  }

  @override
  Future<List<AccountTransaction>> retrieveTransactions(String accessToken, Account account) async {
    String accountId = account.accountId;
    List<Map<String, dynamic>> results = await _getResultsFromTL(
      "https://api.truelayer.com/data/v1/accounts/$accountId/transactions",
      {HttpHeaders.authorizationHeader: "Bearer " + accessToken},
    );

    List<AccountTransaction> list = new List();
    for (int i = 0; i < results.length; i++) {
      Map<String, dynamic> result = results[i];
      AccountTransaction transaction = _accountTransactionFromResult(result, account.key);
      list.add(transaction);
    }

    return list;
  }

  Account _accountFromResult(Map<String, dynamic> map, int keyAccessToken) {
    String updateTimestamp = map['update_timestamp'] as String;
    String accountId = map['account_id'] as String;
    String accountType = map['account_type'] as String;
    String name = map['display_name'] as String;
    String currency = map['currency'] as String;
    Map<String, dynamic> accountNumber = map['account_number'] as Map<String, dynamic>;
    String iban = accountNumber['iban'] as String;
    if (iban == null) {
      iban = ""; //todo sort out
    }
    String swiftBic = accountNumber['swift_bic'] as String;
    String number = accountNumber['number'] as String;
    if (number == null) {
      number = ""; //todo sort out
    }
    String sortCode = accountNumber['sort_code'] as String;
    if (sortCode == null) {
      sortCode = ""; //todo sort out
    }

    Map<String, dynamic> provider = map['provider'] as Map<String, dynamic>;
    String providerName = provider['display_name'] as String;
    String providerId = provider['provider_id'] as String;
    String logoUri = provider['logo_uri'] as String;

    return Account(updateTimestamp, accountId, accountType, name, currency, iban, swiftBic, number, sortCode, providerName, providerId, logoUri, keyAccessToken);
  }

  AccountTransaction _accountTransactionFromResult(Map<String, dynamic> map, int keyAccount) {
    var timestamp = map['timestamp'] as String;
    var description = map['description'] as String;
    var transactionType = map['transaction_type'] as String;
    var transactionCategory = map['transaction_category'] as String;
    //var transactionClassification = map['transaction_classification'];
    var amount = map['amount'] as double;
    var currency = map['currency'] as String;
    var transactionId = map['transaction_id'] as String;

    return AccountTransaction(timestamp, description, transactionType, transactionCategory, amount, currency, transactionId, keyAccount);
  }

  Future<List<Map<String, dynamic>>> _getResultsFromTL(String s, Map<String, String> map) async {
    var response = await http.doGetAndGetJsonResponse(s, map);
    String error = response['error'] as String;
    if (error != null) {
      throw Exception(error);
    }

    return response['results'] as List<Map<String, dynamic>>;
  }
}
