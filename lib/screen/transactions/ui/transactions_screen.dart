import 'package:bankr/data/repository/transaction_repository.dart';
import 'package:bankr/screen/accounts/provider_info.dart';
import 'package:bankr/screen/transactions/bloc/transactions_screen_bloc.dart';
import 'package:bankr/screen/transactions/bloc/transactions_screen_event.dart';
import 'package:bankr/screen/transactions/bloc/transactions_screen_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionsScreen extends StatefulWidget {
  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: BlocBuilder<TransactionsScreenBloc, TransactionsScreenState>(
          bloc: BlocProvider.of(context),
          builder: (BuildContext context, TransactionsScreenState state) {
            if (state is StateSuccess) {
              var dateTransactionsInfos = state.dateTransactionsInfos;
              return ListView.builder(
                itemCount: dateTransactionsInfos.length,
                itemBuilder: (BuildContext context, int position) {
                  DateTransactionsInfo transactionRow = dateTransactionsInfos[position];
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
            }
            BlocProvider.of<TransactionsScreenBloc>(context).add(TransactionsScreenLoaded());
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),


      ),
    );
  }

  List<Widget> createWidgets (DateTransactionsInfo transactionRow)
  {
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
    for (AccountTransactionRow accountTransaction in transactionRow.accountTransactions)
    {
      var row = Row(
        children: <Widget>[
	        Flexible(
		        child: Row(
			        children: [
				        Padding(
					        padding: const EdgeInsets.all(8.0),
					        child: getImage(accountTransaction.accountProvider, 20),
				        ),
				        Flexible(
					        child: Text(
						        accountTransaction.description,
					        ),
				        ),
			        ],
		        ),
	        ),
	        Text(
		        accountTransaction.amount.toString(),
		        textAlign: TextAlign.right,
          ),
        ],
      );

      widgets.add(row);
    }
    return widgets;
  }
}
