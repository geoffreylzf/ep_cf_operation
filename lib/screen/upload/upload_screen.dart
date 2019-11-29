import 'package:ep_cf_operation/mixin/simple_alert_dialog_mixin.dart';
import 'package:ep_cf_operation/res/string.dart';
import 'package:ep_cf_operation/screen/upload/upload_bloc.dart';
import 'package:ep_cf_operation/widget/simple_alert_dialog.dart';
import 'package:ep_cf_operation/widget/simple_loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class UploadScreen extends StatefulWidget {
  static const String route = '/upload';

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> with SimpleAlertDialogMixin {
  UploadBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = UploadBloc(mixin: this);
  }

  @override
  Widget build(BuildContext context) {
    return Provider<UploadBloc>(
      builder: (_) => bloc,
      dispose: (_, value) => value.dispose(),
      child: WillPopScope(
        onWillPop: () async {
          final res = bloc.getIsLoading();
          if (res) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SimpleAlertDialog(
                    title: Strings.error,
                    message: "Uploading data, please wait",
                  );
                });
          }
          return !res;
        },
        child: Scaffold(
          appBar: AppBar(title: Text(Strings.upload)),
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Expanded(child: UploadList()),
                    ActionPanel(),
                  ],
                ),
              ),
              Consumer<UploadBloc>(
                builder: (ctx, value, child) {
                  return SimpleLoadingDialog(value.isLoadingStream);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UploadList extends StatefulWidget {
  @override
  _UploadListState createState() => _UploadListState();
}

class _UploadListState extends State<UploadList> {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<UploadBloc>(context);

    return ListView(
      children: [
        UploadCountRow(FontAwesomeIcons.dizzy, Strings.mortality, bloc.mortalityCountStream),
        UploadCountRow(FontAwesomeIcons.weight, Strings.bodyWeight, bloc.weightCountStream),
        UploadCountRow(FontAwesomeIcons.seedling, Strings.feed, bloc.feedInCountStream),
      ],
    );
  }
}

class UploadCountRow extends StatefulWidget {
  final IconData iconData;
  final String desc;
  final Stream<int> stream;

  UploadCountRow(this.iconData, this.desc, this.stream);

  @override
  _UploadCountRowState createState() => _UploadCountRowState();
}

class _UploadCountRowState extends State<UploadCountRow> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
            borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 4, right: 12, bottom: 4),
                  child: Icon(
                    widget.iconData,
                  ),
                ),
                Text(
                  widget.desc,
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            StreamBuilder<int>(
                initialData: 0,
                stream: widget.stream,
                builder: (context, snapshot) {
                  return Text(
                    snapshot.data.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
    final bloc = Provider.of<UploadBloc>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: double.infinity,
          child: RaisedButton.icon(
            onPressed: () {
              bloc.upload();
            },
            icon: Icon(Icons.cloud_upload),
            label: Text(Strings.upload.toUpperCase()),
          ),
        ),
      ],
    );
  }
}
