class OAuthRequestGenerator {
  final String _identifier;
  final String _secret;
  final String _redirectUrl;

  OAuthRequestGenerator(this._identifier, this._secret, this._redirectUrl);

  Map<String, String> generateAuthorizationJson(String code) {
    return {
      "grant_type": "authorization_code",
      "client_id": _identifier,
      "client_secret": _secret,
      "redirect_uri": _redirectUrl,
      "code": code,
    };
  }

  Map<String, String> generateRefreshJson(String refreshToken) {
    return {
      "grant_type": "refresh_token",
      "client_id": _identifier,
      "client_secret": _secret,
      "refresh_token": refreshToken,
    };
  }
}
