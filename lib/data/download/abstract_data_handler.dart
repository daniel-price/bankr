import 'package:bankr/data/download/download_parameters.dart';
import 'package:bankr/data/download/downloaded_data.dart';

abstract class AbstractDataHandler {
  Future<bool> execute(DownloadParameters downloadParameters, DownloadedData downloadedData);

  bool shouldExecute(DownloadParameters downloadParameters);
}
