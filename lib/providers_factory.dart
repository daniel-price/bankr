import 'package:bankr/api/i_api_adapter.dart';
import 'package:bankr/api/true_layer_api_adapter.dart';
import 'package:bankr/auth/o_auth_access_token_retriever.dart';
import 'package:bankr/auth/o_auth_code_generator.dart';
import 'package:bankr/auth/o_auth_director.dart';
import 'package:bankr/configuration.dart';
import 'package:bankr/data_downloader.dart';
import 'package:bankr/json/model_json_converters.dart';
import 'package:bankr/model/access_token_model.dart';
import 'package:bankr/model/account.dart';
import 'package:bankr/model/account_transaction.dart';
import 'package:bankr/repository/i_dao.dart';
import 'package:bankr/repository/sembast_dao.dart';
import 'package:bankr/util/http.dart';
import 'package:http/io_client.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

import 'file:///C:/bankr/lib/access_token_store.dart';

import 'auth/o_auth_json_generator.dart';

class ProvidersFactory {
  static List<SingleChildWidget> providers;

  static Future<List<SingleChildWidget>> initialize ()
  async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    final dbPath = join(appDocumentDir.path, 'demo.db');
    final database = await databaseFactoryIo.openDatabase(dbPath);

    var store = intMapStoreFactory.store('access_token');

    var accessTokenJsonConverter = AccessTokenModelJsonConverter();

    final IDao<AccessToken> accessTokenRepositoryI = SembastDao(store, database, accessTokenJsonConverter);

    var ioClient = new IOClient();
    var http = new Http(ioClient);

    var oAuthCodeGenerator = OAuthCodeGenerator(Configuration.AUTH_URL, Configuration.CALLBACK_URL_SCHEME);

    var oAuthAccessTokenRetriever = OAuthAccessTokenRetriever(http, Configuration.CREATE_POST_URL, AccessTokenModelJsonConverter());

    var oAuthJsonGenerator = OAuthJsonGenerator(Configuration.IDENTIFIER, Configuration.SECRET, Configuration.CALLBACK_URL_SCHEME + "://" + Configuration.CALLBACK_URL_HOST);

    final OAuthDirector oAuthAuthenticatorI = OAuthDirector(oAuthAccessTokenRetriever, oAuthCodeGenerator, oAuthJsonGenerator);

    var accountStore = intMapStoreFactory.store('account');
    IDao<Account> accountRepository = SembastDao(accountStore, database, AccountModelJsonConverter());

    var transactionStore = intMapStoreFactory.store('transaction');
    IDao<AccountTransaction> accountTransactionRepository = SembastDao(transactionStore, database, AccountTransactionModelJsonConverter());

    var validAccessTokenRepository = AccessTokenStore(oAuthAuthenticatorI, accessTokenRepositoryI);

    IApiAdapter apiInterfaceI = TrueLayerApiAdapter(http);

    DataDownloader dataHandler = DataDownloader(validAccessTokenRepository, accountRepository, accountTransactionRepository, apiInterfaceI);

    dataHandler.updateAll();

    providers = [
      Provider<DataDownloader>(create: (context) => dataHandler),
      Provider<IDao<Account>>(create: (context) => accountRepository),
      Provider<IDao<AccountTransaction>>(create: (context) => accountTransactionRepository),
    ];

    return providers;
  }
}
