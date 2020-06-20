import 'package:bankr/data/download/data_retriever.dart';
import 'package:bankr/data/download/data_saver.dart';
import 'package:bankr/data/download/downloaded_data.dart';
import 'package:bankr/data/model/account.dart';
import 'package:bankr/data/model/account_provider.dart';
import 'package:bankr/data/model/account_provider_update_audit.dart';

class DataDownloader {
  final DataRetriever _dataRetriever;
  final DataSaver _dataSaver;

  DataDownloader(this._dataRetriever, this._dataSaver);

  Future<bool> downloadAllData(String uuidAccessToken) async {
    DownloadedData downloadedData = await _dataRetriever.retrieveAllData(uuidAccessToken);
    if (downloadedData == null) {
      return false;
    }
    await _dataSaver.save(downloadedData);
    return true;
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
