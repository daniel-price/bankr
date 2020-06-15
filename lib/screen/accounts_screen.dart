import 'package:bankr/screen/accounts_screen_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountsScreen extends StatefulWidget {
  @override
  _AccountsScreenState createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  AccountsScreenController controller;

  @override
  Widget build(BuildContext context) {
    controller = Provider.of<AccountsScreenController>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Accounts'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: FutureBuilder(
            future: controller.getAllAccounts(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data.length as int,
                  itemBuilder: (BuildContext context, int position) {
                    AccountRow accountRow = snapshot.data[position] as AccountRow;
                    return Card(
                      color: Colors.white,
                      elevation: 2.0,
                      child: ListTile(
                        title: Row(
                          children: <Widget>[
                            Expanded(
                              child: Center(
                                child: accountRow.getImage(),
                              ),
                              flex: 10,
                            ),
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    accountRow.accountName,
                                  ),
                                  Text(
                                    accountRow.lastUpdatedDesc,
                                  ),
                                ],
                                crossAxisAlignment: CrossAxisAlignment.start,
                              ),
                              flex: 50,
                            ),
                            Expanded(
                              child: Text(accountRow.currentAccountBalance),
                              flex: 20,
                            ),
                          ],
                        ),
                        //subtitle: Text(account.key.toString()),
                        onTap: () {},
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
      ),
      floatingActionButton: FloatingActionButton(
	      onPressed: ()
	      async {
          bool accessTokenAdded = await controller.addAccessToken();
          if (!accessTokenAdded && mounted)
          {
            final snackBar = SnackBar(content: Text("Unable to authenticate"));
            Scaffold.of(context).showSnackBar(snackBar);
          }
        },
        tooltip: 'Add accounts',
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _refresh ()
  async {
	  var allUpdated = await controller.updateAllProviders();
	  if (mounted)
	  {
		  setState(()
		  {});
		  if (!allUpdated)
		  {
        final snackBar = SnackBar(content: Text("Unable to refresh"));
        Scaffold.of(context).showSnackBar(snackBar);
      }
    }
  }
}
