import 'package:bankr/screen/accounts_screen_controller.dart';
import 'package:bankr/screen/transactions_screen_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountsScreen extends StatefulWidget {
  @override
  _AccountsScreenState createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  AccountsScreenController _accountsScreenController;
  TransactionsScreenController _transactionsScreenController;

  @override
  Widget build(BuildContext context) {
    _accountsScreenController = Provider.of<AccountsScreenController>(context);
    _transactionsScreenController = Provider.of<TransactionsScreenController>(context);
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
            future: _accountsScreenController.getProviderRows(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data.length as int,
                  itemBuilder: (BuildContext context, int position) {
                    ProviderRow providerRow = snapshot.data[position] as ProviderRow;
                    /*return ExpansionTile(
                      leading: Container(
                        child: providerRow.getImage(40),
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                      ),
                      title: Row(
                        children: [
                          Text(providerRow.providerDesc),
                          //Text(providerRow.totalBalanceDesc),
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      ),
                      subtitle: Text(
                        providerRow.lastUpdatedDesc,
                      ),
                      trailing: Text(
                        providerRow.totalBalanceDesc,
                        textScaleFactor: 1.1,
                        textAlign: TextAlign.start,
                      ),
                      children: generateAccountRowWidgets(providerRow.accountRows),
                    );*/
                    return Card(
                      child: Column(
                        children: [
                          ListTile(
                            leading: Container(
                              child: getImage(providerRow.accountProvider, 40),
                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                            ),
                            title: Row(
                              children: [
                                Text(providerRow.providerDesc),
                                //Text(providerRow.totalBalanceDesc),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                            subtitle: Text(
                              providerRow.lastUpdatedDesc,
                            ),
                            trailing: Text(
                              providerRow.totalBalanceDesc,
                              textScaleFactor: 1.1,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Column(
                            children: generateAccountRowWidgets(providerRow.accountRows),
                          )
                        ],
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
        onPressed: () async {
          bool accessTokenAdded = await _accountsScreenController.addAccessToken();
          if (!accessTokenAdded && mounted) {
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
    var allUpdated = await _accountsScreenController.updateAllProviders();
    _transactionsScreenController.invalidateCache();
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

  generateAccountRowWidgets (List<AccountRow> accountRows)
  {
    var accountRowWidgets = List<Widget>();
    for (AccountRow accountRow in accountRows)
    {
      var listTile = ListTile(
        title: Text(accountRow.accountName),
        //subtitle: getSubtitle(accountRow),
        trailing: Text(accountRow.accountBalanceDesc),
      );
      accountRowWidgets.add(listTile);
    }

    return accountRowWidgets;
  }

  Text getSubtitle (AccountRow accountRow)
  {
    if (accountRow.number == '')
    {
      return null;
    }
    return Text('${accountRow.number} \r\n${accountRow.sortCode}');
  }
}
