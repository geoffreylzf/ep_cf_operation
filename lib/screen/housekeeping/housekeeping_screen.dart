import 'package:ep_cf_operation/mixin/simple_alert_dialog_mixin.dart';
import 'package:ep_cf_operation/res/string.dart';
import 'package:ep_cf_operation/screen/housekeeping/housekeeping_bloc.dart';
import 'package:ep_cf_operation/widget/simple_loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HousekeepingScreen extends StatefulWidget {
  static const String route = '/housekeeping';

  @override
  _HousekeepingScreenState createState() => _HousekeepingScreenState();
}

class _HousekeepingScreenState extends State<HousekeepingScreen> with SimpleAlertDialogMixin {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<HousekeepingBloc>(
          builder: (_) => HousekeepingBloc(mixin: this),
          dispose: (_, value) => value.dispose(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(Strings.housekeeping),
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: HkList(),
                    ),
                  ),
                  ActionPanel(),
                ],
              ),
            ),
            Consumer<HousekeepingBloc>(builder: (ctx, value, child) {
              return SimpleLoadingDialog(value.isLoadingStream);
            })
          ],
        ),
      ),
    );
  }
}

class HkList extends StatefulWidget {
  @override
  _HkListState createState() => _HkListState();
}

class _HkListState extends State<HkList> {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<HousekeepingBloc>(context);

    return ListView(
      children: [
        HkRow(Strings.branch, bloc.branchCountStream),
        HkRow(Strings.feed, bloc.feedCountStream),
      ],
    );
  }
}

class HkRow extends StatefulWidget {
  final String desc;
  final Stream<int> stream;

  HkRow(this.desc, this.stream);

  @override
  _HkRowState createState() => _HkRowState();
}

class _HkRowState extends State<HkRow> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        color: Theme.of(context).primaryColorLight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.desc),
            StreamBuilder<int>(
                initialData: 0,
                stream: widget.stream,
                builder: (context, snapshot) {
                  return Text(
                    snapshot.data.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  );
                }),
          ],
        ),
      ),
    );
  }
}

class ActionPanel extends StatefulWidget {
  @override
  _ActionPanelState createState() => _ActionPanelState();
}

class _ActionPanelState extends State<ActionPanel> {
  @override
  Widget build(BuildContext context) {
    final hkBloc = Provider.of<HousekeepingBloc>(context);
    return SizedBox(
      width: double.infinity,
      child: RaisedButton.icon(
        onPressed: () {
          hkBloc.retrieveAll();
        },
        icon: Icon(Icons.cloud_download),
        label: Text(Strings.retrieveHousekeeping.toUpperCase()),
      ),
    );
  }
}
