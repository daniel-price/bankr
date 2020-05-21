import 'package:bankr/data/model/account.dart';
import 'package:bankr/screen/accounts_screen_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountsScreen extends StatefulWidget {
  @override
  _AccountsScreenState createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  @override
  Widget build(BuildContext context) {
    AccountsScreenController controller = Provider.of<AccountsScreenController>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Accounts'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: FutureBuilder(
	        future: controller.getAllAccounts(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length as int,
                itemBuilder: (BuildContext context, int position) {
	                Account account = snapshot.data[position] as Account;
                  return Card(
                    color: Colors.white,
                    elevation: 2.0,
                    child: ListTile(
                      title: Text(
	                      account.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
	                    subtitle: Text(account.key.toString()),
	                    onTap: ()
	                    {},
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
	      onPressed: ()
	      async {
		      bool accessTokenAdded = await controller.addAccessToken();
		      if (!accessTokenAdded)
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
}
