import 'package:bankr/auth/access_token.dart';
import 'package:bankr/auth/oauth/o_auth_access_token_retriever.dart';
import 'package:bankr/auth/oauth/o_auth_code_generator.dart';
import 'package:bankr/auth/oauth/o_auth_request_generator.dart';

class OAuthAuthenticator {
  final OAuthAccessTokenRetriever _oAuthAccessTokenRetriever;
  final OAuthCodeGenerator _oAuthCodeGenerator;
  final OAuthRequestGenerator _oAuthJsonGenerator;

  OAuthAuthenticator(this._oAuthAccessTokenRetriever, this._oAuthCodeGenerator, this._oAuthJsonGenerator);

  Future<AccessToken> authenticate() async {
    String code = await _oAuthCodeGenerator.generate();
    if (code == null) {
      return null;
    }
    var map = _oAuthJsonGenerator.generateAuthorizationJson(code);
    return await _oAuthAccessTokenRetriever.retrieve(map);
  }

  Future<AccessToken> refresh(String refreshToken) async {
    var map = _oAuthJsonGenerator.generateRefreshJson(refreshToken);
    return await _oAuthAccessTokenRetriever.retrieve(map);
  }
}
