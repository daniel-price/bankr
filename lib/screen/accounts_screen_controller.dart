import 'package:bankr/data/download/data_downloader.dart';
import 'package:bankr/data/model/account.dart';
import 'package:bankr/data/model/account_balance.dart';
import 'package:bankr/data/model/account_provider.dart';
import 'package:bankr/data/model/account_provider_update_audit.dart';
import 'package:bankr/data/model/i_persist.dart';
import 'package:bankr/data/repository/i_dao.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oauth_http/oauth_http.dart';

class AccountsScreenController {
  final IDao<Account> _accountDao;
  final IDao<AccountBalance> _accountBalanceDao;
  final OAuthHttp _authHttp;
  final DataDownloader _downloadMediator;
  final IDao<AccountProvider> _accountProviderDao;
  final IDao<AccountProviderUpdateAudit> _accountProviderUpdateAuditDao;

  AccountsScreenController(this._accountDao, this._authHttp, this._downloadMediator, this._accountBalanceDao, this._accountProviderDao, this._accountProviderUpdateAuditDao);

  Future<List<AccountRow>> getAllAccounts() async {
    var accounts = await _accountDao.getAll();

    List<AccountRow> accountRows = List();
    for (Account account in accounts) {
      AccountBalance latestAccountBalance = await _accountBalanceDao.getLatestMatch(ColumnNameAndData('uuidAccount', account.uuid), 'updateTimeStamp');
      AccountProvider accountProvider = await _accountProviderDao.getMatch(ColumnNameAndData('uuid', account.uuidProvider));
      AccountProviderUpdateAudit latestAccountProviderUpdateAudit =
      await _accountProviderUpdateAuditDao.getLatestMatch(ColumnNameAndData('uuidAccountProvider', accountProvider.uuid), 'updateTimestamp');
      var accountRow = AccountRow(account, latestAccountBalance, accountProvider, latestAccountProviderUpdateAudit);
      accountRows.add(accountRow);
    }

    /*var allUpdateAudits = await _accountProviderUpdateAuditDao.getAll();
    allUpdateAudits.forEach((element) {
    	print(element.updatedTime);
    });*/
    return accountRows;
  }

  Future<bool> addAccessToken() async {
    var uuidAccessToken = await _authHttp.authenticate();
    if (uuidAccessToken == null)
    {
      return false;
    }
    return await _downloadMediator.downloadAllData(uuidAccessToken);
  }

  Future<bool> updateAllProviders ()
  async {
    bool allUpdated = true;
    var accountProviders = await _accountProviderDao.getAll();
    for (AccountProvider accountProvider in accountProviders)
    {
      var accounts = await _accountDao.getAllMatches(ColumnNameAndData('uuidProvider', accountProvider.uuid));
      var downloaded = await _downloadMediator.update(accountProvider, accounts);
      var providerUpdateAudit = AccountProviderUpdateAudit.factory(accountProvider.uuid, DateTime.now(), downloaded);
      await _accountProviderUpdateAuditDao.insert(providerUpdateAudit);
      print('updated for accountProvider ${accountProvider.displayName}, ${accounts.length} accounts');
      allUpdated = allUpdated && downloaded;
    }

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

  void testMethod ()
  async {
    var dao = _accountBalanceDao;
    var allElements = await dao.getAll();
    print(allElements.length);
    allElements.forEach((element)
    {
      dao.delete(element);
    });
  }
}

class AccountRow
{
  final Account _account;
  final AccountBalance _accountBalance;
  final AccountProvider _accountProvider;
  final AccountProviderUpdateAudit _accountProviderUpdateAudit;

  AccountRow (this._account, this._accountBalance, this._accountProvider, this._accountProviderUpdateAudit);

  AccountBalance get accountBalance
  => _accountBalance;

  String get accountName
  => _account.name;

  String get currentAccountBalance
  => _accountBalance?.current.toString() ?? "Downloading...";

  String get lastUpdatedDesc
  {
    if (_accountProviderUpdateAudit == null)
    {
      return 'Downloading...';
    }

    var lastUpdatedDescPrefix = getLastUpdatedDescPrefix();

    return '$lastUpdatedDescPrefix: ${_accountProviderUpdateAudit.updatedTime.toString()}';
  }

  String getLastUpdatedDescPrefix ()
  {
    if (_accountProviderUpdateAudit.success)
    {
      return 'Last updated at';
    }
    return 'Failed to update at';
  }

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
