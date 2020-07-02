import 'package:bankr/screen/accounts/bloc/accounts_screen_bloc.dart';
import 'package:bankr/screen/accounts/bloc/accounts_screen_event.dart';
import 'package:bankr/screen/accounts/bloc/accounts_screen_state.dart';
import 'package:bankr/screen/accounts/provider_info.dart';
import 'package:bankr/screen/accounts/ui/provider_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountsPanel extends StatefulWidget {
  @override
  _AccountsPanelState createState() => _AccountsPanelState();
}

class _AccountsPanelState extends State<AccountsPanel> {
  @override
  Widget build(BuildContext context) {
    var accountsBloc = BlocProvider.of<AccountsScreenBloc>(context);
    return BlocBuilder<AccountsScreenBloc, AccountsScreenState>(builder: (context, state) {
      if (state is StateSuccess) {
        List<Widget> allPanels = List();
        var providerInfos = state.providerInfos;
        for (ProviderInfo providerInfo in providerInfos) {
          var providerCard = ProviderCard(providerInfo: providerInfo);
          allPanels.add(providerCard);
        }

        return Container(
          child: Column(
            children: allPanels,
          ),
        );
      }

      accountsBloc.add(AccountsLoaded());
      return Container();
    });
  }
}
