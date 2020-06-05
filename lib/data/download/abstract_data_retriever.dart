import 'package:bankr/api/i_api_adapter.dart';
import 'package:bankr/data/download/abstract_data_handler.dart';
import 'package:bankr/data/download/download_parameters.dart';
import 'package:bankr/data/download/downloaded_data.dart';

abstract class AbstractDataRetriever<T> implements AbstractDataHandler {
  final IApiAdapter apiAdapter;

  AbstractDataRetriever(this.apiAdapter);

  Future<T> retrieve(DownloadParameters dataBuilder, DownloadedData downloadedData);

  void setData(DownloadedData downloadedData, T data);

  @override
  Future<bool> execute(DownloadParameters downloadParameters, DownloadedData downloadedData) async {
    T data = await retrieve(downloadParameters, downloadedData);
    if (data == null) {
      print('data is null for ' + this.toString());
      return false;
    }

    setData(downloadedData, data);
    return true;
  }

  @override
  bool shouldExecute(DownloadParameters downloadParameters) {
    return true;
  }
}
