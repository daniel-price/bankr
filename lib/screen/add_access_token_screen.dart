import 'package:bankr/Configuration.dart';
import 'package:bankr/repository/access_token_memory_repository.dart';
import 'package:bankr/trueLayer/access_token_retriever.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SAddAccessToken extends StatefulWidget {
  @override
  _SAddAccessTokenState createState() => _SAddAccessTokenState();
}

class _SAddAccessTokenState extends State<SAddAccessToken> {
  TextEditingController _textInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accounts'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: <Widget>[
            RaisedButton(
              onPressed: _launchTLInBrowser,
            ),
            TextField(
              controller: _textInputController,
            ),
            RaisedButton(
              onPressed: _submitPressed,
              child: Text('Submit'),
            )
          ],
        ),
      ),
    );
  }

  addAccessToken(String code) async {
    var tlAccessTokenRetriever = new TLAccessTokenRetriever(code);
    var accessToken = await tlAccessTokenRetriever.retrieve();
    AccessTokenMemoryRepository.getInstance().insert(accessToken);
  }

  void _submitPressed() {
    addAccessToken(_textInputController.text);
    Navigator.pop(context);
  }

  void _launchTLInBrowser() async {
    await launch(Configuration.TL_GRANT_ACCESS_URL);
  }
}
