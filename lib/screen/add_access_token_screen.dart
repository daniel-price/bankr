import 'package:bankr/Configuration.dart';
import 'package:bankr/repository/access_token_repositoryI.dart';
import 'package:bankr/trueLayer/access_token_retriever.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SAddAccessToken extends StatefulWidget {
  @override
  _SAddAccessTokenState createState() => _SAddAccessTokenState();
}

class _SAddAccessTokenState extends State<SAddAccessToken> {
  TextEditingController _textInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var accessTokenRepositoryI = Provider.of<AccessTokenRepositoryI>(context);
    var tlAccessTokenRetriever = Provider.of<TLAccessTokenRetrieverI>(context);
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
              child: Text('Get code'),
            ),
            TextField(
              controller: _textInputController,
            ),
            RaisedButton(
              onPressed: () async {
                var accessToken = await tlAccessTokenRetriever.retrieve(
                    _textInputController.text);
                accessTokenRepositoryI.insert(accessToken);
                Navigator.pop(context);
              },
              child: Text('Submit'),
            ),
            RaisedButton(
              onPressed: ()
              async {
                accessTokenRepositoryI.delete(null);
              },
              child: Text('Test Button'),
            )
          ],
        ),
      ),
    );
  }

  void _launchTLInBrowser() async {
    await launch(Configuration.TL_GRANT_ACCESS_URL);
  }
}
