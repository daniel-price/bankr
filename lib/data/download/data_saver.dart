import 'package:bankr/data/dao/i_dao.dart';
import 'package:bankr/data/download/downloaded_data.dart';
import 'package:bankr/data/model/account.dart';
import 'package:bankr/data/model/account_balance.dart';
import 'package:bankr/data/model/account_provider.dart';
import 'package:bankr/data/model/account_provider_update_audit.dart';
import 'package:bankr/data/model/account_transaction.dart';

class DataSaver {
	final IDao<AccountProvider> _accountProviderDao;
	final IDao<Account> _accountDao;
	final IDao<AccountBalance> _accountBalanceDao;
	final IDao<AccountTransaction> _accountTransactionDao;
	final IDao<AccountProviderUpdateAudit> _accountProviderUpdateAuditDao;

	DataSaver(this._accountProviderDao, this._accountDao, this._accountBalanceDao, this._accountTransactionDao, this._accountProviderUpdateAuditDao);

	save(DownloadedData downloadedData) async {
		await _accountProviderDao.insertIfNew(downloadedData.accountProvider);
		await _accountDao.insertAllNew(downloadedData.accounts);
		await _accountBalanceDao.insertAllNew(downloadedData.accountBalances);
		await _accountTransactionDao.insertAllNew(downloadedData.accountTransactions);

		await saveAudit(downloadedData.accountProvider.uuid, true);
	}

	saveAudit (String uuidAccountProvider, bool success)
	async {
		var providerUpdateAudit = AccountProviderUpdateAudit.factory(uuidAccountProvider, DateTime.now(), success);
		await _accountProviderUpdateAuditDao.insert(providerUpdateAudit);
	}
}
