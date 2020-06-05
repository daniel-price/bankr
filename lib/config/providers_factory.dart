import 'package:bankr/api/i_api_adapter.dart';
import 'package:bankr/api/true_layer_api_adapter.dart';
import 'package:bankr/auth/access_token_store.dart';
import 'package:bankr/auth/oauth/o_auth_access_token_retriever.dart';
import 'package:bankr/auth/oauth/o_auth_authenticator.dart';
import 'package:bankr/auth/oauth/o_auth_code_generator.dart';
import 'package:bankr/auth/oauth/o_auth_request_generator.dart';
import 'package:bankr/auth/repository/access_token_repository_secure_storage.dart';
import 'package:bankr/auth/repository/i_access_token_repository.dart';
import 'package:bankr/config/configuration.dart';
import 'package:bankr/data/download/download_mediator.dart';
import 'package:bankr/data/json/model_json_converters.dart';
import 'package:bankr/data/model/account.dart';
import 'package:bankr/data/model/account_balance.dart';
import 'package:bankr/data/model/account_transaction.dart';
import 'package:bankr/data/repository/i_dao.dart';
import 'package:bankr/data/repository/sembast_dao.dart';
import 'package:bankr/screen/accounts_screen_controller.dart';
import 'package:bankr/screen/transactions_screen_controller.dart';
import 'package:bankr/util/http.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/io_client.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class ProvidersFactory {
  static List<SingleChildWidget> providers;

  static Future<List<SingleChildWidget>> initialize() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    final dbPath = join(appDocumentDir.path, 'demo.db');
    final database = await databaseFactoryIo.openDatabase(dbPath);

    var flutterSecureStorage = new FlutterSecureStorage();
    final IAccessTokenRepository accessTokenRepositoryI = AccessTokenRepositorySecureStorage(flutterSecureStorage);

    var ioClient = new IOClient();
    var http = new Http(ioClient);

    var oAuthCodeGenerator = OAuthCodeGenerator(Configuration.AUTH_URL, Configuration.CALLBACK_URL_SCHEME);

    var oAuthAccessTokenRetriever = OAuthAccessTokenRetriever(http, Configuration.CREATE_POST_URL);

    var oAuthJsonGenerator = OAuthRequestGenerator(Configuration.IDENTIFIER, Configuration.SECRET, Configuration.CALLBACK_URL_SCHEME + "://" + Configuration.CALLBACK_URL_HOST);

    final OAuthAuthenticator oAuthAuthenticatorI = OAuthAuthenticator(oAuthAccessTokenRetriever, oAuthCodeGenerator, oAuthJsonGenerator);

    var accountStore = stringMapStoreFactory.store('account');
    IDao<Account> accountRepository = SembastDao(accountStore, database, AccountJsonConverter());

    var accountBalanceStore = stringMapStoreFactory.store('accountBalance');
    IDao<AccountBalance> accountBalanceRepository = SembastDao(accountBalanceStore, database, AccountBalanceJsonConverter());

    var transactionStore = stringMapStoreFactory.store('transaction');
    IDao<AccountTransaction> accountTransactionRepository = SembastDao(transactionStore, database, AccountTransactionJsonConverter());

    var providerStore = stringMapStoreFactory.store('provider');
    IDao<AccountProvider> accountProviderRepository = SembastDao(providerStore, database, AccountProviderJsonConverter());

    var accessTokenStore = AccessTokenStore(oAuthAuthenticatorI, accessTokenRepositoryI);

    IApiAdapter apiInterfaceI = TrueLayerApiAdapter(http, accessTokenStore);

    DataRetriever dataRetriever = DataRetriever(apiInterfaceI);
    DataSaver dataSaver = DataSaver(accountProviderRepository, accountRepository, accountBalanceRepository, accountTransactionRepository);

    var downloadMediator = DownloadMediator(dataRetriever, dataSaver);

    var accountsScreenController = AccountsScreenController(accountRepository, accessTokenStore, downloadMediator, accountBalanceRepository, accountProviderRepository);
    var transactionsScreenController = TransactionsScreenController(accountTransactionRepository, accountRepository);

    providers = [
	    Provider<AccountsScreenController>(create: (context)
	    => accountsScreenController),
	    Provider<TransactionsScreenController>(create: (context)
	    => transactionsScreenController),
    ];

    return providers;
  }
}
