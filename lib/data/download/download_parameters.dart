class DownloadParameters {
  final String _uuidAccessToken;
  final bool _firstRetrieve;

  DownloadParameters(this._uuidAccessToken, this._firstRetrieve);

  String get uuidAccessToken => _uuidAccessToken;

  bool get firstRetrieve => _firstRetrieve;
}
