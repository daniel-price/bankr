import 'package:bankr/data/download/data_retriever.dart';
import 'package:bankr/data/download/data_saver.dart';
import 'package:bankr/data/download/downloaded_data.dart';
import 'package:bankr/data/model/account.dart';
import 'package:bankr/data/model/account_provider.dart';
import 'package:oauth_http/oauth_http.dart';

class DataDownloader {
  final OAuthHttp _authHttp;
  final DataRetriever _dataRetriever;
  final DataSaver _dataSaver;

  DataDownloader(this._authHttp, this._dataRetriever, this._dataSaver);

  Future<String> downloadAllData() async {
    var uuidAccessToken = await _authHttp.authenticate();
    if (uuidAccessToken == null) {
      return null;
    }
    DownloadedData downloadedData = await _dataRetriever.retrieveAllData(uuidAccessToken);
    if (downloadedData == null) {
      return null;
    }
    await _dataSaver.save(downloadedData);
    return uuidAccessToken;
  }

  Future<bool> update(AccountProvider accountProvider, List<Account> accounts) async {
    DownloadedData downloadedData = await _dataRetriever.retrieveBalancesAndTransactions(accountProvider, accounts);
    if (downloadedData == null) {
      _dataSaver.saveAudit(accountProvider.uuid, false);
      return false;
    }
    await _dataSaver.save(downloadedData);
    return true;
  }
}
