import 'dart:collection';

import 'package:bankr/api/i_api_adapter.dart';
import 'package:bankr/api/true_layer/true_layer_account_provider_reference_data.dart';
import 'package:bankr/data/model/account.dart';
import 'package:bankr/data/model/account_balance.dart';
import 'package:bankr/data/model/account_provider.dart';
import 'package:bankr/data/model/account_transaction.dart';
import 'package:bankr/util/date_range.dart';
import 'package:oauth_http/oauth_http.dart';

class TrueLayerApiAdapter extends IApiAdapter {
  final OAuthHttp _oAuthHttp;
  final HashMap<String, TrueLayerAccountProviderReferenceData> _accountProviderReferenceDataById;

  TrueLayerApiAdapter(this._oAuthHttp, this._accountProviderReferenceDataById);

  @override
  Future<List<Account>> retrieveAccounts(String uuidAccessToken, String uuidProvider) async {
    var results = await _oAuthHttp.doGet(
      "https://api.truelayer.com/data/v1/accounts",
      uuidAccessToken,
    );

    if (results == null) {
      return null;
    }

    List<Account> accounts = new List();
    for (int i = 0; i < results.length; i++) {
      Map<String, dynamic> result = results[i] as Map<String, dynamic>;
      Account account = _accountFromResult(result, uuidProvider);
      accounts.add(account);
    }

    return accounts;
  }

  @override
  Future<List<AccountTransaction>> retrieveTransactions(String uuidAccessToken, Account account, [DateRange dateRange]) async {
    String url = "https://api.truelayer.com/data/v1/accounts/${account.accountId}/transactions";
    if (dateRange != null)
    {
      url += '?from=${dateRange.fromAsISOString}&to=${dateRange.toAsISOString}';
    }
    var results = await _oAuthHttp.doGet(
      url,
      uuidAccessToken,
    );

    if (results == null)
    {
      return null;
    }

    List<AccountTransaction> list = new List();
    for (int i = 0; i < results.length; i++) {
      Map<String, dynamic> result = results[i] as Map<String, dynamic>;
      AccountTransaction transaction = _accountTransactionFromResult(result, account.uuid);
      list.add(transaction);
    }

    return list;
  }

  Account _accountFromResult (Map<String, dynamic> map, String uuidProvider)
  {
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

    return Account(
        updateTimestamp,
        accountId,
        accountType,
        name,
        currency,
        iban,
        swiftBic,
        number,
        sortCode,
        uuidProvider);
  }

  AccountTransaction _accountTransactionFromResult (Map<String, dynamic> map, String uuidAccount)
  {
    var timestamp = map['timestamp'] as String;
    var description = map['description'] as String;
    var transactionType = map['transaction_type'] as String;
    var transactionCategory = map['transaction_category'] as String;
    //var transactionClassification = map['transaction_classification'];
    var amount = map['amount'] as double;
    var currency = map['currency'] as String;
    var transactionId = map['transaction_id'] as String;
    var merchantName = map['merchant_name'] as String;

    return AccountTransaction(
        timestamp,
        description,
        transactionType,
        transactionCategory,
        amount,
        currency,
        transactionId,
        merchantName,
        uuidAccount);
  }

  @override
  Future<AccountBalance> retrieveBalance (String uuidAccessToken, Account account)
  async {
    var results = await _oAuthHttp.doGet(
      "https://api.truelayer.com/data/v1/accounts/${account.accountId}/balance",
      uuidAccessToken,
    );

    if (results == null)
    {
      return null;
    }

    //TODO - change to assert
    if (results.length != 1)
    {
      print("expected 1 result but got ${results.length}");
    }

    Map<String, dynamic> result = results[0] as Map<String, dynamic>;
    return _accountBalanceFromResult(result, account.uuid);
  }

  AccountBalance _accountBalanceFromResult (Map<String, dynamic> map, String uuidAccount)
  {
    var currency = map['currency'] as String;
    var available = map['available'] as double;
    var current = map['current'] as double;
    double overdraft = getAsDouble(map['overdraft']);

    var updateTimestamp = map['update_timestamp'] as String;

    return AccountBalance(currency, available, current, overdraft, updateTimestamp, uuidAccount);
  }

  double getAsDouble (dynamic number)
  {
    if (number == null || number.runtimeType == double)
    {
      return number as double;
    }

    return double.parse(number.toString());
  }

  @override
  Future<AccountProvider> retrieveAccountProvider (String uuidAccessToken)
  async {
    var results = await _oAuthHttp.doGet(
      "https://api.truelayer.com/data/v1/me",
      uuidAccessToken,
    );

    if (results == null)
    {
      return null;
    }

    //TODO - change to assert
    if (results.length != 1)
    {
      print("expected 1 result but got ${results.length}");
    }

    Map<String, dynamic> result = results[0] as Map<String, dynamic>;
    return _accountProviderFromResult(result, uuidAccessToken);
  }

  AccountProvider _accountProviderFromResult (Map<String, dynamic> map, String uuidAccessToken)
  {
    var provider = map['provider'] as Map<String, dynamic>;
    var displayName = provider['display_name'] as String;
    var logoUri = provider['logo_uri'] as String;
    var providerId = provider['provider_id'] as String;

    var accountProvider = _accountProviderReferenceDataById[providerId];
    var dataAccessSavingsDays = accountProvider?.dataAccessSavingsDays ?? 90;
    var dataCardsDays = accountProvider?.dataCardsDays ?? 90;
    var canRequestAllDataAtAnyTime = accountProvider?.canRequestAllDataAtAnyTime ?? false;
    var logoSvg = accountProvider?.logoSvg ?? '';

    return AccountProvider(
      displayName,
      logoUri,
      providerId,
      dataAccessSavingsDays,
      dataCardsDays,
      canRequestAllDataAtAnyTime,
      logoSvg,
      uuidAccessToken,
    );
  }
}

IApiAdapter factoryTrueLayerApiAdapter (OAuthHttp oAuthHttp)
{
  HashMap<String, TrueLayerAccountProviderReferenceData> accountProviderReferenceDataById = factoryAccountProviderReferenceDataById();
  return TrueLayerApiAdapter(oAuthHttp, accountProviderReferenceDataById);
}
