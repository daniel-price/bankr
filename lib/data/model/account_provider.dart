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
      : super(uuid);

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
