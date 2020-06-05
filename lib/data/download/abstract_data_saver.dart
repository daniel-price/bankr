import 'package:bankr/data/download/abstract_data_handler.dart';
import 'package:bankr/data/download/download_parameters.dart';
import 'package:bankr/data/download/downloaded_data.dart';
import 'package:bankr/data/model/i_persist.dart';
import 'package:bankr/data/repository/i_dao.dart';

abstract class AbstractDataSaver<T extends IPersist> implements AbstractDataHandler {
  final IDao<T> _dao;

  AbstractDataSaver(this._dao);

  @override
  Future<bool> execute(DownloadParameters downloadParameters, DownloadedData downloadedData) async {
    List<T> dataList = getDataList(downloadedData);
    await _saveNew(dataList);
    return true;
  }

  List<T> getDataList(DownloadedData downloadedData);

  Future<void> _saveNew(List<T> dataList) async {
    var allExisting = await _dao.getAll();
    for (T persist in dataList) {
      _saveIfNew(persist, allExisting);
    }
  }

  void _saveIfNew(T persist, List<T> allExisting) async {
    for (T existing in allExisting) {
      if (persist.sameAs(existing)) {
        return;
      }
    }
    await _dao.insert(persist);
  }

  @override
  bool shouldExecute(DownloadParameters downloadParameters) {
    return true;
  }
}
