import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'file:///C:/Projects/bankr/lib/screen/accounts/ui/accounts_screen.dart';
import 'file:///C:/Projects/bankr/lib/screen/transactions/ui/transactions_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _children = [AccountsScreen(), TransactionsScreen(), DevScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.account_balance),
            title: new Text('Accounts'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.mail),
            title: new Text('Transactions'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.settings),
            title: new Text('Dev'),
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

class DevScreen extends StatefulWidget
{
	@override
	_DevScreenState createState ()
	=> _DevScreenState();
}

class _DevScreenState extends State<DevScreen>
{
	@override
	Widget build (BuildContext context)
	{
		return Scaffold(
			appBar: AppBar(
				title: Text('Transactions'),
			),
			body: Container(
				width: double.infinity,
				height: double.infinity,
				child: Column(
					children: <Widget>[
						RaisedButton(
							onPressed: ()
							{
							},
							child: const Text('Test', style: TextStyle(fontSize: 20)),
						)
					],
				),
			),
		);
	}
}