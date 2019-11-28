import 'package:ep_cf_operation/mixin/simple_alert_dialog_mixin.dart';
import 'package:ep_cf_operation/model/feed_in_qr.dart';
import 'package:ep_cf_operation/model/table/branch.dart';
import 'package:ep_cf_operation/res/string.dart';
import 'package:ep_cf_operation/screen/feed_in/feed_in_bloc.dart';
import 'package:ep_cf_operation/screen/feed_in_detail/feed_in_detail_screen.dart';
import 'package:ep_cf_operation/util/node_util.dart';
import 'package:ep_cf_operation/widget/display_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FeedInScreen extends StatefulWidget {
  static const String route = '/feedIn';

  @override
  _FeedInScreenState createState() => _FeedInScreenState();
}

class _FeedInScreenState extends State<FeedInScreen> with SimpleAlertDialogMixin {
  @override
  Widget build(BuildContext context) {
    return Provider<FeedInBloc>(
      builder: (_) => FeedInBloc(mixin: this),
      dispose: (_, value) => value.dispose(),
      child: Scaffold(
        appBar: AppBar(title: Text(Strings.newFeedIn)),
        body: FeedInEntry(),
      ),
    );
  }
}

class FeedInEntry extends StatefulWidget {
  @override
  _FeedInEntryState createState() => _FeedInEntryState();
}

class _FeedInEntryState extends State<FeedInEntry> {
  final dateFormat = DateFormat('yyyy-MM-dd');
  final dateTec = TextEditingController();
  final truckNoTec = TextEditingController();

  var recordDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    dateTec.text = dateFormat.format(recordDate);
  }

  @override
  void dispose() {
    dateTec.dispose();
    truckNoTec.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<FeedInBloc>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Icon(Icons.place, size: 14),
              ),
              StreamBuilder<Branch>(
                stream: bloc.locationStream,
                builder: (context, snapshot) {
                  var locationName = "";
                  if (snapshot.hasData) {
                    locationName = snapshot.data.branchName;
                  }
                  return Text(
                    locationName,
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  );
                },
              ),
            ],
          ),
          TextField(
            controller: dateTec,
            enableInteractiveSelection: false,
            focusNode: AlwaysDisabledFocusNode(),
            onTap: () async {
              final selectedDate = await showDatePicker(
                context: context,
                initialDate: recordDate,
                firstDate: DateTime.now().add(Duration(days: -2)),
                lastDate: DateTime.now(),
              );

              if (selectedDate != null) {
                recordDate = selectedDate;
                dateTec.text = dateFormat.format(selectedDate);
              }
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.date_range),
              labelText: Strings.recordDate,
              contentPadding: EdgeInsets.all(16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: StreamBuilder<FeedInQr>(
                      stream: bloc.feedInQrStream,
                      builder: (context, snapshot) {
                        var docNo = "";
                        if (snapshot.hasData) {
                          docNo = snapshot.data.headData.docNo.toString();
                        }
                        return DisplayField(title: "Document No", value: docNo);
                      }),
                ),
                Container(
                  width: 8,
                ),
                Expanded(
                  child: TextField(
                    controller: truckNoTec,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: Strings.truckNo,
                      prefixIcon: Icon(Icons.local_shipping),
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: RaisedButton.icon(
                    icon: Icon(Icons.settings_overscan),
                    label: Text(Strings.scan.toUpperCase()),
                    onPressed: () async {
                      final feedInQr = await bloc.scan();
                      if (feedInQr != null) {
                        truckNoTec.text = feedInQr.headData.truckNo;
                      } else {
                        truckNoTec.text = "";
                      }
                    },
                  ),
                ),
                Container(
                  width: 8,
                ),
                Expanded(
                  child: RaisedButton.icon(
                    icon: Icon(Icons.save),
                    label: Text(Strings.save.toUpperCase()),
                    onPressed: () async {
                      final recordDate = dateTec.text;
                      final truckNo = truckNoTec.text;
                      final cfFeedIn = bloc.validateEntry(recordDate, truckNo);
                      final feedInQr = bloc.getFeedInQr();

                      if (cfFeedIn != null) {
                        Navigator.pushNamed(
                          context,
                          FeedInDetailScreen.route,
                          arguments: FeedInDetailScreenArguments(cfFeedIn, feedInQr),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: StreamBuilder<FeedInQr>(
                stream: bloc.feedInQrStream,
                builder: (context, snapshot) {
                  var docId = "";
                  if (snapshot.hasData) {
                    docId = snapshot.data.headData.docId.toString();
                  }
                  return Text(docId.toString(),
                      style: TextStyle(color: Colors.grey[300], fontSize: 12));
                }),
          ),
        ],
      ),
    );
  }
}
