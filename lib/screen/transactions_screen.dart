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
				  builder: (BuildContext context, AsyncSnapshot snapshot)
				  {
					  if (snapshot.hasData)
					  {
						  return ListView.builder(
							  itemCount: snapshot.data.length as int,
							  itemBuilder: (BuildContext context, int position)
							  {
								  AccountTransaction transaction = snapshot.data[position] as AccountTransaction;
								  return Card(
									  color: Colors.white,
									  elevation: 2.0,
									  child: ListTile(
										  title: Text(
											  transaction.amount.toString(),
											  style: TextStyle(fontWeight: FontWeight.bold),
										  ),
										  subtitle: Text(transaction.key.toString()),
										  onTap: ()
										  {},
									  ),
								  );
							  },
						  );
					  } else
					  {
						  return Center(
							  child: CircularProgressIndicator(),
						  );
					  }
				  },
			  ),
		  ),
	  );
  }
}
