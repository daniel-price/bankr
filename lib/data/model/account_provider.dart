import 'package:bankr/data/model/i_persist.dart';

class AccountProvider extends IPersist {
  final String _displayName;
  final String _logoUri;
  final String _providerId;
  final int _dataAccessSavingsDays;
  final int _dataCardsDays;
  final bool _canRequestAllDataAtAnyTime;
  final String _logoSvg;
  final String _uuidAccessToken;

  AccountProvider(this._displayName, this._logoUri, this._providerId, this._dataAccessSavingsDays, this._dataCardsDays, this._canRequestAllDataAtAnyTime, this._logoSvg, this._uuidAccessToken,
      [String uuid])
      : super(uuid) {
    assert(this._displayName != null);
    assert(this._logoUri != null);
    assert(this._providerId != null);
    assert(this._dataAccessSavingsDays != null);
    assert(this._dataCardsDays != null);
    assert(this._canRequestAllDataAtAnyTime != null);
    assert(this._logoSvg != null);
    assert(this._uuidAccessToken != null);
    assert(this.uuid != null);
  }

  String get displayName => _displayName;

  String get logoUri => _logoUri;

  String get providerId => _providerId;

  int get dataAccessSavingsDays => _dataAccessSavingsDays;

  int get dataCardsDays => _dataCardsDays;

  bool get canRequestAllDataAtAnyTime => _canRequestAllDataAtAnyTime;

  String get logoSvg => _logoSvg;

  String get uuidAccessToken => _uuidAccessToken;

  @override
  ColumnNameAndData get apiReferenceData => ColumnNameAndData('providerId', providerId);
}
