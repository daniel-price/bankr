import 'package:bankr/data/download/abstract_data_handler.dart';
import 'package:bankr/data/download/download_parameters.dart';
import 'package:bankr/data/download/downloaded_data.dart';

class DownloadMediator {
  final List<AbstractDataHandler> _dataHandlers;

  DownloadMediator(this._dataHandlers);

  Future<bool> download(DownloadParameters downloadParameters, DownloadedData downloadedData) async {
    for (AbstractDataHandler abstractDataHandler in _dataHandlers) {
      if (abstractDataHandler.shouldExecute(downloadParameters)) {
        bool success = await abstractDataHandler.execute(downloadParameters, downloadedData);
        if (!success) {
          return false;
        }
      }
    }

    return true;
  }
}
