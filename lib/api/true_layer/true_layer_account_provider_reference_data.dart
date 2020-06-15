class TLAccountProviderReferenceData {
  final int _dataAccessSavingsDays;
  final int _dataCardsDays;
  final bool _canRequestAllDataAtAnyTime;
  final String _logoSvg;

  TLAccountProviderReferenceData(this._dataAccessSavingsDays, this._dataCardsDays, this._canRequestAllDataAtAnyTime, this._logoSvg);

  int get dataAccessSavingsDays => _dataAccessSavingsDays;

  int get dataCardsDays => _dataCardsDays;

  bool get canRequestAllDataAtAnyTime => _canRequestAllDataAtAnyTime;

  String get logoSvg => _logoSvg;
}
