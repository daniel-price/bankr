import 'package:bankr/api/i_api_adapter.dart';
import 'package:bankr/api/true_layer/true_layer_api_adapter.dart';
import 'package:bankr/config/config.dart';
import 'package:bankr/data/dao/sembast/sembast_dao_factory.dart';
import 'package:bankr/data/download/data_downloader.dart';
import 'package:bankr/data/download/data_retriever.dart';
import 'package:bankr/data/download/data_saver.dart';
import 'package:bankr/data/repository/account_repository.dart';
import 'package:bankr/data/repository/transaction_repository.dart';
import 'package:bankr/screen/accounts/bloc/accounts_screen_bloc.dart';
import 'package:bankr/screen/accounts/bloc/download_bloc.dart';
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

  var transactionsScreenBloc = TransactionsScreenBloc(dateTransactionsInfoRepository);
  var accountsScreenBloc = AccountsScreenBloc(accountRepository, dataDownloader);
  var downloadBloc = DownloadBloc(dataDownloader, transactionsScreenBloc, accountsScreenBloc);

  return [
	  BlocProvider<AccountsScreenBloc>(
		  create: (context)
		  => accountsScreenBloc,
	  ),
	  BlocProvider<DownloadBloc>(
		  create: (context)
		  => downloadBloc,
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
	var identifier = Configuration.IDENTIFIER; //get by signing up on truelayer.com
	var secret = Configuration.SECRET; //get by signing up on truelayer.com
	var callbackUrlScheme = Configuration.CALLBACK_URL_SCHEME; //Also need to set this in AndroidManifest.xml
	var callBackUrlHost = Configuration.CALLBACK_URL_HOST; //Also need to set this in AndroidManifest.xml

	var createPostUrl = 'https://auth.truelayer.com/connect/token';
	var redirectUrl = '$callbackUrlScheme://$callBackUrlHost';
	var authUrl = 'https://auth.truelayer.com/?response_type=code'
			'&client_id=$identifier'
			'&scope=info%20accounts%20balance%20cards%20transactions%20direct_debits%20standing_orders%20offline_access'
			'&redirect_uri=$redirectUrl'
			'&providers=uk-ob-all%20uk-oauth-all';

	return OAuthHttp.factory(authUrl, callbackUrlScheme, createPostUrl, identifier, secret, redirectUrl);
}
