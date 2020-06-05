import 'package:bankr/api/true_layer_api_adapter.dart';
import 'package:bankr/auth/access_token_store.dart';
import 'package:bankr/data/download/download_mediator.dart';
import 'package:bankr/data/download/download_parameters.dart';
import 'package:bankr/data/download/downloaded_data.dart';
import 'package:bankr/data/model/account.dart';
import 'package:bankr/data/model/account_balance.dart';
import 'package:bankr/data/repository/i_dao.dart';
import 'package:bankr/util/hashmap_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AccountsScreenController {
  final IDao<Account> _accountDao;
  final IDao<AccountBalance> _accountBalanceDao;
  final AccessTokenStore _accessTokenStore;
  final DownloadMediator _downloadMediator;
  final IDao<AccountProvider> _accountProviderDao;

  AccountsScreenController(this._accountDao, this._accessTokenStore, this._downloadMediator, this._accountBalanceDao, this._accountProviderDao);

  Future<List<AccountRow>> getAllAccounts() async {
    var accounts = await _accountDao.getAll();
    var accountBalances = await _accountBalanceDao.getAll();
    var accountProviders = await _accountProviderDao.getAll();

    List<AccountRow> accountRows = List();
    for (Account account in accounts) {
      AccountBalance accountBalance = getAccountBalance(accountBalances, account);
      AccountProvider accountProvider = getAccountProvider(accountProviders, account);
      accountRows.add(AccountRow(account, accountBalance, accountProvider));
    }
    return accountRows;
  }

  Future<bool> addAccessToken() async {
    var keyAccessToken = await _accessTokenStore.addAccessToken();
    if (keyAccessToken == null) {
      return false;
    }
    var downloadedData = DownloadedData();
    return _downloadMediator.download(DownloadParameters(keyAccessToken, true), downloadedData);
  }

  Future<bool> updateAllAccounts ()
  async {
    bool allUpdated = true;
    var accounts = await _accountDao.getAll();

    HashMapList<String, Account> accountsByUuidAccessToken = new HashMapList<String, Account>();
    for (Account account in accounts)
    {
      accountsByUuidAccessToken.add(account.uuidAccessToken, account);
    }

    await accountsByUuidAccessToken.forEach((uuidAccessToken, accounts)
    async {
      var downloadParameters = DownloadParameters(uuidAccessToken, false);
      var downloadedData = DownloadedData();
      downloadedData.accounts = accounts;
      var downloaded = await _downloadMediator.download(downloadParameters, downloadedData);
      allUpdated = allUpdated && downloaded;
    });

    return allUpdated;
  }

  AccountBalance getAccountBalance (List<AccountBalance> accountBalances, Account account)
  {
    AccountBalance latestAccountBalance;
    for (AccountBalance accountBalance in accountBalances)
    {
      if (accountBalance.uuidAccount == account.uuid && (latestAccountBalance == null || accountBalance.updated.isAfter(latestAccountBalance.updated)))
      {
        latestAccountBalance = accountBalance;
      }
    }
    return latestAccountBalance;
  }

  AccountProvider getAccountProvider (List<AccountProvider> accountProviders, Account account)
  {
    for (AccountProvider accountProvider in accountProviders)
    {
      if (accountProvider.uuid == account.uuidProvider)
      {
        return accountProvider;
      }
    }
    return null;
  }
}

class AccountRow
{
  final Account _account;
  final AccountBalance _accountBalance;
  final AccountProvider _accountProvider;

  AccountRow (this._account, this._accountBalance, this._accountProvider);

  AccountBalance get accountBalance
  => _accountBalance;

  String get accountName
  => _account.name;

  String get currentAccountBalance
  => _accountBalance?.current.toString() ?? "Downloading...";

  Widget getImage ()
  {
    if (_accountProvider.logoSvg != null)
    {
      return SvgPicture.asset(
        _accountProvider.logoSvg,
        height: 25,
      );
    }

    return SvgPicture.network(
      _accountProvider.logoUri,
      placeholderBuilder: (BuildContext context)
      =>
          Container(
            padding: const EdgeInsets.all(30.0),
            child: const CircularProgressIndicator(),
            height: 25,
          ),
      height: 25,
    );
  }
}
