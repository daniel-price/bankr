import 'dart:io';

import 'package:bankr/api/i_api_adapter.dart';
import 'package:bankr/auth/access_token_store.dart';
import 'package:bankr/data/model/account.dart';
import 'package:bankr/data/model/account_balance.dart';
import 'package:bankr/data/model/account_transaction.dart';
import 'package:bankr/data/model/i_persist.dart';
import 'package:bankr/util/http.dart';

import 'file:///C:/bankr/lib/data/download/account_provider_reference_data.dart';

class TrueLayerApiAdapter extends IApiAdapter {
  final Http _http;
  final AccessTokenStore _accessTokenStore;

  TrueLayerApiAdapter(this._http, this._accessTokenStore);

  @override
  Future<List<Account>> retrieveAccounts(String uuidAccessToken, String uuidProvider) async {
    var results = await _doGet(
      "https://api.truelayer.com/data/v1/accounts",
      uuidAccessToken,
    );

    if (results == null)
    {
      return null;
    }

    List<Account> accounts = new List();
    for (int i = 0; i < results.length; i++) {
      Map<String, dynamic> result = results[i] as Map<String, dynamic>;
      Account account = _accountFromResult(result, uuidAccessToken, uuidProvider);
      accounts.add(account);
    }

    return accounts;
  }

  @override
  Future<List<AccountTransaction>> retrieveTransactions (String uuidAccessToken, Account account, [DateRange dateRange])
  async {
    String url = "https://api.truelayer.com/data/v1/accounts/${account.accountId}/transactions";
    if (dateRange != null)
    {
      url += '?from=${dateRange.fromAsISOString}&to=${dateRange.toAsISOString}';
    }
    var results = await _doGet(
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

  Account _accountFromResult (Map<String, dynamic> map, String uuidAccessToken, String uuidProvider)
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
        uuidAccessToken,
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

  Future<List> _doGet (String url, String uuidAccessToken)
  async {
    var token = await _accessTokenStore.getToken(uuidAccessToken);
    var response = await _http.doGetAndGetJsonResponse(
      url,
      {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    if (response == null)
    {
      return null;
    }

    return response['results'] as List<dynamic>;
  }

  @override
  Future<AccountBalance> retrieveBalance (String uuidAccessToken, Account account)
  async {
    var results = await _doGet(
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
  Future<AccountProvider> retrieveProvider (String uuidAccessToken)
  async {
    var results = await _doGet(
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
    return _accountProviderFromResult(result);
  }

  AccountProvider _accountProviderFromResult (Map<String, dynamic> map)
  {
    var provider = map['provider'] as Map<String, dynamic>;
    var displayName = provider['display_name'] as String;
    var logoUri = provider['logo_uri'] as String;
    var providerId = provider['provider_id'] as String;

    var accountProvider = AccountProviderReferenceDataCache.getAccountProvider(providerId);
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
        logoSvg);
  }
}

class AccountProvider extends IPersist
{
  final String _displayName;
  final String _logoUri;
  final String _providerId;
  final int _dataAccessSavingsDays;
  final int _dataCardsDays;
  final bool _canRequestAllDataAtAnyTime;
  final String _logoSvg;

  AccountProvider (this._displayName, this._logoUri, this._providerId, this._dataAccessSavingsDays, this._dataCardsDays, this._canRequestAllDataAtAnyTime, this._logoSvg, [String uuid]) : super(uuid);

  String get displayName
  => _displayName;

  String get logoUri
  => _logoUri;

  String get providerId
  => _providerId;

  int get dataAccessSavingsDays
  => _dataAccessSavingsDays;

  int get dataCardsDays
  => _dataCardsDays;

  bool get canRequestAllDataAtAnyTime
  => _canRequestAllDataAtAnyTime;

  String get logoSvg
  => _logoSvg;

  @override
  bool sameAs (IPersist other)
  {
    return other is AccountProvider && other.providerId == providerId;
  }
}

class DateRange
{
  final DateTime from;
  final DateTime to;

  DateRange (this.from, this.to);

  String get toAsISOString
  => asIsoString(to);

  String get fromAsISOString
  => asIsoString(from);

  String asIsoString (DateTime dateTime)
  {
    var iso8601string = dateTime.toIso8601String();
    return iso8601string.split('.')[0];
  }
}
