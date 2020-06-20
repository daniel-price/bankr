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

  Future<List<ProviderRow>> getProviderRows ()
  async {
    var providerRows = List<ProviderRow>();

    var accountProviders = await _accountProviderDao.getAll();
    for (AccountProvider accountProvider in accountProviders)
    {
      AccountProviderUpdateAudit latestAccountProviderUpdateAudit =
      await _accountProviderUpdateAuditDao.getLatestMatch(ColumnNameAndData('uuidAccountProvider', accountProvider.uuid), 'updateTimestamp');
      var accountRows = await factoryAccountRows(accountProvider);
      var providerRow = ProviderRow(accountProvider, latestAccountProviderUpdateAudit, accountRows);
      providerRows.add(providerRow);
    }

    return providerRows;
  }

  factoryAccountRows (AccountProvider accountProvider)
  async {
    var accountRows = List<AccountRow>();
    var accounts = await _accountDao.getAllMatches(ColumnNameAndData('uuidProvider', accountProvider.uuid));
    for (Account account in accounts) {
      AccountBalance latestAccountBalance = await _accountBalanceDao.getLatestMatch(ColumnNameAndData('uuidAccount', account.uuid), 'updateTimeStamp');
      var accountRow = AccountRow(account, latestAccountBalance);
      accountRows.add(accountRow);
    }

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

class ProviderRow
{
  final AccountProvider _accountProvider;
  final AccountProviderUpdateAudit _accountProviderUpdateAudit;
  final List<AccountRow> _accountRows;

  ProviderRow (this._accountProvider, this._accountProviderUpdateAudit, this._accountRows);

  String get lastUpdatedDesc
  {
    if (_accountProviderUpdateAudit == null)
    {
      return 'Downloading...';
    }

    var lastUpdatedDescPrefix = getLastUpdatedDescPrefix();

    var lastUpdatedDescSuffix = getLastUpdatedDescSuffix();

    return '$lastUpdatedDescPrefix $lastUpdatedDescSuffix';
  }

  String get providerDesc
  => _accountProvider?.displayName ?? 'Downloading...';

  String get totalBalanceDesc
  {
    var totalBalance = 0.0;
    for (AccountRow accountRow in _accountRows)
    {
      var accountBalance = accountRow.accountBalance;
      var current = accountBalance.current;
      totalBalance += current;
    }

    return getBalanceDesc(totalBalance);
  }

  get accountProvider
  => _accountProvider;

  String get providerId
  => _accountProvider.providerId;


  String getLastUpdatedDescPrefix ()
  {
    if (_accountProviderUpdateAudit.success)
    {
      return 'Last updated';
    }
    return 'Failed to update';
  }

  List<AccountRow> get accountRows
  => _accountRows;

  getLastUpdatedDescSuffix ()
  {
    var now = DateTime.now();
    var updatedTime = _accountProviderUpdateAudit.updatedTime;
    var difference = now.difference(updatedTime);
    var differenceInDays = difference.inDays;
    if (differenceInDays > 1)
    {
      return '$differenceInDays days ago';
    }

    var differenceInHours = difference.inHours;
    if (differenceInHours > 1)
    {
      return '$differenceInHours hours ago';
    }

    var differenceInMinutes = difference.inMinutes;
    if (differenceInMinutes > 1)
    {
      return '$differenceInMinutes minutes ago';
    }

    return '< 1 minute ago';
  }
}

class AccountRow
{
  final Account _account;
  final AccountBalance _accountBalance;

  AccountRow (this._account, this._accountBalance);

  AccountBalance get accountBalance
  => _accountBalance;

  String get accountBalanceDesc
  => getBalanceDesc(accountBalance.current);

  String get accountName
  => _account.name;

  String get currentAccountBalance
  => _accountBalance?.current.toString() ?? "Downloading...";

  String get number
  => _account.number;

  String get sortCode
  => _account.sortCode;

  String get accountType
  => _account.accountType;
}

String getBalanceDesc (double totalBalance)
=> '£' + totalBalance.toStringAsFixed(2);

Widget getImage (AccountProvider accountProvider, double height)
{
  if (accountProvider.logoSvg != null)
  {
    return SvgPicture.asset(
      accountProvider.logoSvg,
      height: height,
    );
  }

  return SvgPicture.network(
    accountProvider.logoUri,
    placeholderBuilder: (BuildContext context)
    => const CircularProgressIndicator(),
    height: height,
  );
}