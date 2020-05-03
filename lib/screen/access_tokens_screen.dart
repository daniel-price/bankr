import 'package:bankr/model/access_token.dart';
import 'package:bankr/repository/access_token_repositoryI.dart';
import 'package:bankr/screen/add_access_token_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SAccessTokens extends StatefulWidget {
  @override
  _SAccessTokensState createState() => _SAccessTokensState();
}

class _SAccessTokensState extends State<SAccessTokens> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accounts'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: FutureBuilder(
          future: _getAllAccessTokens(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int position) {
                  AccessToken accessToken = snapshot.data[position];
                  return Card(
                    color: Colors.white,
                    elevation: 2.0,
                    child: ListTile(
                      title: Text(
                        accessToken.expiresAtStr,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(accessToken.key.toString()),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addAccessToken(),
        tooltip: 'Add access token',
        child: Icon(Icons.add),
      ),
    );
  }

  _getAllAccessTokens() async {
    return await Provider.of<AccessTokenRepositoryI>(context).getAccessTokens();
  }

  _addAccessToken() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SAddAccessToken()),
    );
  }
}
