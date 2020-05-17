import 'package:bankr/api/i_api_adapter.dart';
import 'package:bankr/model/access_token_model.dart';
import 'package:bankr/model/account.dart';
import 'package:bankr/model/account_transaction.dart';
import 'package:bankr/repository/i_dao.dart';

import 'file:///C:/bankr/lib/access_token_store.dart';

class DataDownloader {
  final AccessTokenStore _accessTokenHandler;
  final IDao<Account> _accountRepositoryI;
  final IDao<AccountTransaction> _accountTransactionRepositoryI;
  final IApiAdapter _apiInterface;

  DataDownloader(this._accessTokenHandler, this._accountRepositoryI, this._accountTransactionRepositoryI, this._apiInterface);

  void updateAll() async {
    var accessTokens = await _accessTokenHandler.getAll();
    for (AccessToken accessToken in accessTokens) {
      _retrieveAndSaveAllForDataRetriever(accessToken);
    }
  }

  void _retrieveAndSaveAllForDataRetriever(AccessToken accessToken) async {
    List<Account> accounts = await _apiInterface.retrieveAccounts(accessToken.accessToken, accessToken.key);
    for (Account account in accounts) {
      _accountRepositoryI.insertUnique(account);
      List<AccountTransaction> transactions = await _apiInterface.retrieveTransactions(accessToken.accessToken, account);
      for (AccountTransaction transaction in transactions) {
        _accountTransactionRepositoryI.insertUnique(transaction);
      }
    }
  }

  void addNewAccessToken() async {
    var accessToken = await _accessTokenHandler.addAccessToken();
    _retrieveAndSaveAllForDataRetriever(accessToken);
  }
}
