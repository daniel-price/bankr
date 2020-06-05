import 'package:bankr/data/model/account_transaction.dart';
import 'package:bankr/screen/transactions_screen_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionsScreen extends StatefulWidget {
  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  @override
  Widget build(BuildContext context) {
    TransactionsScreenController controller = Provider.of<TransactionsScreenController>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: FutureBuilder(
          future: controller.getAllAccountsTransactions(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length as int,
                itemBuilder: (BuildContext context, int position) {
                  AccountTransactionRow transactionRow = snapshot.data[position] as AccountTransactionRow;
                  return Card(
                      color: Colors.white,
                      elevation: 2.0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: createWidgets(transactionRow),
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                      ));
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
    );
  }

  List<Widget> createWidgets(AccountTransactionRow transactionRow) {
    List<Widget> widgets = List();
    widgets.add(
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          transactionRow.formattedDate,
          textAlign: TextAlign.left,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
    for (AccountTransaction accountTransaction in transactionRow.accountTransactions) {
      var row = Row(
        children: <Widget>[
          Expanded(
            flex: 8,
            child: Text(
              accountTransaction.description,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              accountTransaction.amount.toString(),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      );
      widgets.add(row);
    }
    return widgets;
  }
}
