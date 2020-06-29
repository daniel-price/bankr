import 'dart:async';

import 'package:bankr/screen/accounts/bloc/accounts_panel_bloc.dart';
import 'package:bankr/screen/accounts/bloc/accounts_panel_event.dart';
import 'package:bankr/screen/accounts/bloc/accounts_panel_state.dart';
import 'package:bankr/screen/accounts/provider_info.dart';
import 'package:bankr/screen/accounts/ui/provider_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountsScreen extends StatefulWidget {
  @override
  _AccountsScreenState createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accounts'),
      ),
      body: BlocBuilder<AccountsPanelBloc, AccountsPanelState>(
        builder: (context, state) {
          if (state is StateAccountsAndDownloadsLoaded) {
            _refreshCompleter?.complete();
            _refreshCompleter = Completer();
            List<Widget> allPanels = List();
            for (DownloadInfo downloadInfo in state.downloadInfos) {
              var dismissibleCard = createDismissibleCard(downloadInfo.message, () => BlocProvider.of<AccountsPanelBloc>(context).add(EventClearDownloadCard(downloadInfo.uuid)));
              allPanels.add(dismissibleCard);
            }
            var providerInfos = state.providerInfos;
            providerInfos.sort((a, b) => a.providerId.compareTo(b.providerId));
            for (ProviderInfo providerInfo in providerInfos) {
              var providerCard = ProviderCard(providerInfo: providerInfo);
              allPanels.add(providerCard);
            }

            return RefreshIndicator(
              child: Container(
                child: ListView(
                  children: allPanels,
                ),
              ),
              onRefresh: () {
                for (ProviderInfo providerInfo in state.providerInfos) {
                  String uuidProvider = providerInfo.uuidProvider;
                  BlocProvider.of<AccountsPanelBloc>(context).add(
                    EventRefreshAccounts(uuidProvider),
                  );
                }

                return _refreshCompleter.future;
              },
            );
          }

          BlocProvider.of<AccountsPanelBloc>(context).add(EventRebuildAccounts());
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          BlocProvider.of<AccountsPanelBloc>(context).add(EventDownloadStarted());
        },
        tooltip: 'Add accounts',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget createDismissibleCard(String errorText, void Function() onDismissed) {
    return Dismissible(
      background: stackBehindDismiss(),
      key: UniqueKey(),
      onDismissed: (direction) {
        onDismissed();
      },
      child: Card(
        child: ListTile(
          title: Text('$errorText'),
          subtitle: Text('Swipe to dismiss'),
        ),
      ),
    );
  }

  Widget stackBehindDismiss() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 20.0),
      color: Colors.grey,
      child: Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );
  }
}
