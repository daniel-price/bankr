import 'package:bankr/screen/accounts/provider_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProviderCard extends StatelessWidget {
  const ProviderCard({
    Key key,
    @required this.providerInfo,
  }) : super(key: key);

  final ProviderInfo providerInfo;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Container(
              child: SizedBox(
                child: providerInfo.accountProviderImage,
                width: 40,
                height: 40,
              ),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
            ),
            title: Row(
              children: [
                Text(providerInfo.providerDesc),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            subtitle: Text(
              getLastUpdatedDesc(providerInfo),
              textScaleFactor: 0.9,
            ),
            trailing: Text(
              providerInfo.totalBalanceDesc,
              textScaleFactor: 1.1,
              textAlign: TextAlign.start,
            ),
          ),
          Column(
            children: generateAccountRowWidgets(providerInfo.accountRows),
          )
        ],
      ),
    );
  }
}

getLastUpdatedDesc(ProviderInfo providerRow) {
  return providerRow.lastUpdatedDesc;
}

generateAccountRowWidgets(List<AccountRow> accountRows) {
  var accountRowWidgets = List<Widget>();
  for (AccountRow accountRow in accountRows) {
    var listTile = ListTile(
      title: Text(accountRow.accountName),
      trailing: Text(accountRow.accountBalanceDesc),
    );
    accountRowWidgets.add(listTile);
  }

  return accountRowWidgets;
}
