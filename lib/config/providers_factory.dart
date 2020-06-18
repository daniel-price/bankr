
import 'package:bankr/api/i_api_adapter.dart';
import 'package:bankr/api/true_layer/true_layer_api_adapter.dart';
import 'package:bankr/config/config.dart';
import 'package:bankr/data/download/data_downloader.dart';
import 'package:bankr/data/download/data_retriever.dart';
import 'package:bankr/data/download/data_saver.dart';
import 'package:bankr/data/repository/sembast/sembast_dao_factory.dart';
import 'package:bankr/screen/accounts_screen_controller.dart';
import 'package:bankr/screen/transactions_screen_controller.dart';
import 'package:oauth_http/oauth_http.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

Future<List<SingleChildWidget>> factoryProviders() async {
  var daoFactory = await SembastDaoFactory.initialize();
  var accountDao = daoFactory.factoryAccountDao();
  var accountBalanceDao = daoFactory.factoryAccountBalanceDao();
  var accountTransactionDao = daoFactory.factoryAccountTransactionDao();
  var accountProviderDao = daoFactory.factoryAccountProviderDao();
  var accountProviderUpdateAuditDao = daoFactory.factoryAccountProviderUpdateAuditDao();
  var dataSaver = DataSaver(accountProviderDao, accountDao, accountBalanceDao, accountTransactionDao);
  var authHttp = factoryOAuthHttp();
  var dataDownloader = factoryDataDownloader(dataSaver, authHttp);
  var accountsScreenController = AccountsScreenController(accountDao, authHttp, dataDownloader, accountBalanceDao, accountProviderDao, accountProviderUpdateAuditDao);
  var transactionsScreenController = TransactionsScreenController(accountTransactionDao, accountDao);

  return [
    Provider<AccountsScreenController>(create: (context) => accountsScreenController),
    Provider<TransactionsScreenController>(create: (context) => transactionsScreenController),
  ];
}

DataDownloader factoryDataDownloader(DataSaver dataSaver, OAuthHttp oAuthHttp) {
  IApiAdapter apiAdapter = factoryTrueLayerApiAdapter(oAuthHttp);
  DataRetriever dataRetriever = DataRetriever(apiAdapter);
  return DataDownloader(dataRetriever, dataSaver);
}

OAuthHttp factoryOAuthHttp() {
  return OAuthHttp.factory(Configuration.AUTH_URL, Configuration.CALLBACK_URL_SCHEME, Configuration.CREATE_POST_URL, Configuration.IDENTIFIER, Configuration.SECRET,
      Configuration.CALLBACK_URL_SCHEME + "://" + Configuration.CALLBACK_URL_HOST);
}
