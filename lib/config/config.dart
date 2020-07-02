class Configuration {
  static const String IDENTIFIER = "YOUR-IDENTIFIER";
  static const String SECRET = "YOUR-SECRET";
  static const String CREATE_POST_URL = "https://auth.truelayer.com/connect/token";
  static const String CALLBACK_URL_SCHEME = "bankr"; //Also need to set this in AndroidManifest.xml
  static const String CALLBACK_URL_HOST = "auth"; //Also need to set this in AndroidManifest.xml
}