import 'package:bankr/auth/o_auth_access_token_retriever.dart';
import 'package:bankr/auth/o_auth_code_generator.dart';
import 'package:bankr/auth/o_auth_json_generator.dart';
import 'package:bankr/model/access_token_model.dart';

class OAuthDirector {
  final OAuthAccessTokenRetriever _oAuthAccessTokenRetriever;
  final OAuthCodeGenerator _accessTokenCodeGenerator;
  final OAuthJsonGenerator _oAuthJsonGenerator;

  OAuthDirector(this._oAuthAccessTokenRetriever, this._accessTokenCodeGenerator, this._oAuthJsonGenerator);

  Future<AccessToken> authenticate() async {
    String code = await _accessTokenCodeGenerator.generate();
    var map = _oAuthJsonGenerator.generateAuthorizationJson(code);
    return await _oAuthAccessTokenRetriever.retrieve(map);
  }

  Future<AccessToken> refresh(String refreshToken) async {
    var map = _oAuthJsonGenerator.generateRefreshJson(refreshToken);
    return await _oAuthAccessTokenRetriever.retrieve(map);
  }
}
