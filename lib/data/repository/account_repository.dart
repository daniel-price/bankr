import 'package:bankr/data/dao/i_dao.dart';
import 'package:bankr/data/model/account.dart';
import 'package:bankr/data/model/account_balance.dart';
import 'package:bankr/data/model/account_provider.dart';
import 'package:bankr/data/model/account_provider_update_audit.dart';
import 'package:bankr/data/model/i_persist.dart';
import 'package:bankr/screen/accounts/account_info.dart';
import 'package:bankr/screen/accounts/provider_info.dart';

class ProviderInfoRepository {
  final IDao<Account> _accountDao;
  final IDao<AccountBalance> _accountBalanceDao;
  final IDao<AccountProvider> _accountProviderDao;
  final IDao<AccountProviderUpdateAudit> _accountProviderUpdateAuditDao;
  final List<String> _refreshingAccounts = List();

  ProviderInfoRepository(this._accountDao, this._accountBalanceDao, this._accountProviderDao, this._accountProviderUpdateAuditDao);

  Future<List<ProviderInfo>> getProviderInfos() async {
    List<ProviderInfo> providerInfos = List();

    var accountProviders = await _accountProviderDao.getAll();
    for (AccountProvider accountProvider in accountProviders) {
      var providerInfo = await getProviderInfoForAccountProvider(accountProvider);
      providerInfos.add(providerInfo);
    }

    providerInfos.sort((a, b) => a.providerId.compareTo(b.providerId));
    return providerInfos;
  }

  Future<ProviderInfo> getProviderInfoForAccountProvider(AccountProvider accountProvider) async {
    AccountProviderUpdateAudit latestAccountProviderUpdateAudit =
        await _accountProviderUpdateAuditDao.getLatestMatch(ColumnNameAndData('uuidAccountProvider', accountProvider.uuid), 'updateTimestamp');
    var accountRows = await factoryAccountRows(accountProvider);
    var refreshing = _refreshingAccounts.contains(accountProvider.uuid);
    var providerRow = ProviderInfo(accountProvider, latestAccountProviderUpdateAudit, accountRows, refreshing);
    return providerRow;
  }

  factoryAccountRows(AccountProvider accountProvider) async {
    var accountRows = List<AccountInfo>();
    var accounts = await _accountDao.getAllMatches(ColumnNameAndData('uuidProvider', accountProvider.uuid));
    for (Account account in accounts) {
      AccountBalance latestAccountBalance = await _accountBalanceDao.getLatestMatch(ColumnNameAndData('uuidAccount', account.uuid), 'updateTimeStamp');
      var accountRow = AccountInfo(account, latestAccountBalance);
      accountRows.add(accountRow);
    }

    return accountRows;
  }

  Future<ProviderInfo> getProviderInfo(String uuidProvider) async {
    var accountProvider = await _accountProviderDao.get(uuidProvider);
    return await getProviderInfoForAccountProvider(accountProvider);
  }

  Future<ProviderInfo> getProviderInfoForUuidAccessToken(String uuidAccessToken) async {
    var accountProvider = await _accountProviderDao.getMatch(ColumnNameAndData('uuidAccessToken', uuidAccessToken));
    return await getProviderInfoForAccountProvider(accountProvider);
  }

  addRefreshingProvider(String uuidProvider) {
    _refreshingAccounts.add(uuidProvider);
  }

  removeRefreshingProvider(String uuidProvider) {
    _refreshingAccounts.remove(uuidProvider);
  }
}
