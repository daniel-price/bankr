class Configuration {
  static const String IDENTIFIER = "danielprice-315733";
  static const String SECRET = "97dbbe13-4b97-4896-85a4-56c49afef9fe";
  static const String CREATE_POST_URL = "https://auth.truelayer.com/connect/token";
  static const String AUTH_URL =
      'https://auth.truelayer.com/?response_type=code&client_id=danielprice-315733&scope=info%20accounts%20balance%20cards%20transactions%20direct_debits%20standing_orders%20offline_access&redirect_uri=bankr://auth&providers=uk-ob-all%20uk-oauth-all';
  static const String CALLBACK_URL_SCHEME = "bankr"; //Also need to set this in AndroidManifest.xml
  static const String CALLBACK_URL_HOST = "auth"; //Also need to set this in AndroidManifest.xml
  static const int MINUTES_BEFORE_EXPIRES_TO_REFRESH = 5;
}
