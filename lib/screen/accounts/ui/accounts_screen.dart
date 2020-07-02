
import 'package:bankr/screen/accounts/bloc/accounts_screen_bloc.dart';
import 'package:bankr/screen/accounts/bloc/accounts_screen_event.dart';
import 'package:bankr/screen/accounts/bloc/download_bloc.dart';
import 'package:bankr/screen/accounts/bloc/download_event.dart';
import 'package:bankr/screen/accounts/ui/accounts_panel.dart';
import 'package:bankr/screen/accounts/ui/download_panel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountsScreen extends StatefulWidget {
  @override
  _AccountsScreenState createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accounts'),
      ),
      body: RefreshIndicator(
        child: Container(
          child: ListView(
            children: [DownloadPanel(), AccountsPanel()],
          ),
        ),
        onRefresh: () async => BlocProvider.of<AccountsScreenBloc>(context).add(AllAccountsRefreshed()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          BlocProvider.of<DownloadBloc>(context).add(DownloadStarted());
        },
        tooltip: 'Add accounts',
        child: Icon(Icons.add),
      ),
    );
  }
}
