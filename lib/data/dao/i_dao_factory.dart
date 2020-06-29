import 'package:bankr/data/dao/i_dao.dart';
import 'package:bankr/data/model/account.dart';
import 'package:bankr/data/model/account_balance.dart';
import 'package:bankr/data/model/account_provider.dart';
import 'package:bankr/data/model/account_provider_update_audit.dart';
import 'package:bankr/data/model/account_transaction.dart';

abstract class IDaoFactory {
	IDao<Account> factoryAccountDao();

	IDao<AccountBalance> factoryAccountBalanceDao();

	IDao<AccountTransaction> factoryAccountTransactionDao();

	IDao<AccountProvider> factoryAccountProviderDao();

	IDao<AccountProviderUpdateAudit> factoryAccountProviderUpdateAuditDao();
}
