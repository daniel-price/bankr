import 'package:bankr/config/configuration.dart';

class AccessToken {
  int key;
  final String _accessToken;
  final DateTime _expiresAt;
  final String _tokenType;
  final String _refreshToken;
  final String _scope;

	AccessToken (this._accessToken, this._expiresAt, this._tokenType, this._refreshToken, this._scope, [int this.key]);

  String get accessToken => _accessToken;

  DateTime get expiresAt => _expiresAt;

	String get tokenType
	=> _tokenType;

	String get refreshToken
	=> _refreshToken;

	String get scope
	=> _scope;

	String get expiresAtStr
	=> _expiresAt.toString();

	DateTime get refreshTime
	=> expiresAt.subtract(Duration(minutes: Configuration.MINUTES_BEFORE_EXPIRES_TO_REFRESH));

	bool get shouldRefresh
	=> DateTime.now().isAfter(refreshTime);
}
