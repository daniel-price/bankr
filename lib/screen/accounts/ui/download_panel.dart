import 'package:bankr/screen/accounts/bloc/download_bloc.dart';
import 'package:bankr/screen/accounts/bloc/download_event.dart';
import 'package:bankr/screen/accounts/bloc/download_state.dart';
import 'package:bankr/screen/accounts/download_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DownloadPanel extends StatefulWidget {
  @override
  _DownloadPanelState createState() => _DownloadPanelState();
}

class _DownloadPanelState extends State<DownloadPanel> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DownloadBloc, DownloadState>(
      builder: (context, state) {
        if (state is StateSuccess) {
          List<Widget> allPanels = List();
          for (DownloadInfo downloadInfo in state.downloadInfos) {
            var dismissibleCard = createDismissibleCard(downloadInfo.message, () => BlocProvider.of<DownloadBloc>(context).add(DownloadCardDismissed(downloadInfo)));
            allPanels.add(dismissibleCard);
          }

          return Container(
            child: Column(
              children: allPanels,
            ),
          );
        }
        return Container();
      },
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
