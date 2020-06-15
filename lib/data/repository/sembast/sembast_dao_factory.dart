import 'package:bankr/data/json/i_json_converter.dart';
import 'package:bankr/data/json/model_json_converters.dart';
import 'package:bankr/data/model/account.dart';
import 'package:bankr/data/model/account_balance.dart';
import 'package:bankr/data/model/account_provider.dart';
import 'package:bankr/data/model/account_provider_update_audit.dart';
import 'package:bankr/data/model/account_transaction.dart';
import 'package:bankr/data/model/i_persist.dart';
import 'package:bankr/data/repository/i_dao.dart';
import 'package:bankr/data/repository/i_dao_factory.dart';
import 'package:bankr/data/repository/sembast_dao.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class SembastDaoFactory implements IDaoFactory {
  final Database _database;

  SembastDaoFactory(this._database);

  static Future<SembastDaoFactory> initialize() async {
    var appDocumentDir = await getApplicationDocumentsDirectory();
    var dbPath = join(appDocumentDir.path, 'demo.db');
    var database = await databaseFactoryIo.openDatabase(dbPath);
    return SembastDaoFactory(database);
  }

  IDao<E> factoryDao<E extends IPersist>(String storeName, IJsonConverter<E> jsonConverter) {
    var accountStore = stringMapStoreFactory.store(storeName);
    return SembastDao(accountStore, _database, jsonConverter);
  }

  @override
  IDao<Account> factoryAccountDao() {
    return factoryDao('account', AccountJsonConverter());
  }

  @override
  IDao<AccountBalance> factoryAccountBalanceDao() {
    return factoryDao('accountBalance', AccountBalanceJsonConverter());
  }

  @override
  IDao<AccountProvider> factoryAccountProviderDao() {
    return factoryDao('accountProvider', AccountProviderJsonConverter());
  }

  @override
  IDao<AccountTransaction> factoryAccountTransactionDao() {
    return factoryDao('accountTransaction', AccountTransactionJsonConverter());
  }

  @override
  IDao<AccountProviderUpdateAudit> factoryAccountProviderUpdateAuditDao() {
    return factoryDao('accountProviderUpdateAudit', AccountProviderUpdateAuditJsonConverter());
  }
}
