import 'package:bankr/api/i_api_adapter.dart';
import 'package:bankr/api/true_layer/true_layer_api_adapter.dart';
import 'package:bankr/config/config.dart';
import 'package:bankr/data/dao/sembast/sembast_dao_factory.dart';
import 'package:bankr/data/download/data_downloader.dart';
import 'package:bankr/data/download/data_retriever.dart';
import 'package:bankr/data/download/data_saver.dart';
import 'package:bankr/data/repository/account_repository.dart';
import 'package:bankr/data/repository/transaction_repository.dart';
import 'package:bankr/screen/accounts/bloc/accounts_panel_bloc.dart';
import 'package:bankr/screen/transactions/bloc/transactions_screen_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oauth_http/oauth_http.dart';

Future<List<BlocProvider>> factoryProviders() async {
  var daoFactory = await SembastDaoFactory.initialize();
  var accountDao = daoFactory.factoryAccountDao();
  var accountBalanceDao = daoFactory.factoryAccountBalanceDao();
  var accountTransactionDao = daoFactory.factoryAccountTransactionDao();
  var accountProviderDao = daoFactory.factoryAccountProviderDao();
  var accountProviderUpdateAuditDao = daoFactory.factoryAccountProviderUpdateAuditDao();
  var dataSaver = DataSaver(accountProviderDao, accountDao, accountBalanceDao, accountTransactionDao, accountProviderUpdateAuditDao);
  var authHttp = factoryOAuthHttp();
  var dataDownloader = factoryDataDownloader(dataSaver, authHttp);
  var dateTransactionsInfoRepository = DateTransactionsInfoRepository(accountTransactionDao, accountDao, accountProviderDao);

  var accountRepository = ProviderInfoRepository(accountDao, accountBalanceDao, accountProviderDao, accountProviderUpdateAuditDao);

  var accountsPanelBloc = AccountsPanelBloc(accountRepository, dataDownloader);
  var transactionsScreenBloc = TransactionsScreenBloc(dateTransactionsInfoRepository);

  return [
	  BlocProvider<AccountsPanelBloc>(
		  create: (context)
		  => accountsPanelBloc,
	  ),
	  BlocProvider<TransactionsScreenBloc>(
		  create: (context)
		  => transactionsScreenBloc,
	  ),
  ];
}

DataDownloader factoryDataDownloader(DataSaver dataSaver, OAuthHttp oAuthHttp) {
  IApiAdapter apiAdapter = factoryTrueLayerApiAdapter(oAuthHttp);
  DataRetriever dataRetriever = DataRetriever(apiAdapter);
  return DataDownloader(oAuthHttp, dataRetriever, dataSaver);
}

OAuthHttp factoryOAuthHttp() {
  return OAuthHttp.factory(Configuration.AUTH_URL, Configuration.CALLBACK_URL_SCHEME, Configuration.CREATE_POST_URL, Configuration.IDENTIFIER, Configuration.SECRET,
      Configuration.CALLBACK_URL_SCHEME + "://" + Configuration.CALLBACK_URL_HOST);
}
