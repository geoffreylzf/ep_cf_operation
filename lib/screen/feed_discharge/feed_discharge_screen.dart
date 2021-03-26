import 'package:ep_cf_operation/mixin/simple_alert_dialog_mixin.dart';
import 'package:ep_cf_operation/res/string.dart';
import 'package:ep_cf_operation/screen/feed_discharge/feed_discharge_bloc.dart';
import 'package:ep_cf_operation/screen/feed_discharge_detail/feed_discharge_detail_block.dart';
import 'package:ep_cf_operation/util/node_util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FeedDischargeScreen extends StatefulWidget {
  static const String route = '/feedDischarge';

  @override
  _FeedDischargeScreenState createState() => _FeedDischargeScreenState();
}

class _FeedDischargeScreenState extends State<FeedDischargeScreen> with SimpleAlertDialogMixin {
  @override
  Widget build(BuildContext context) {
    return Provider<FeedDischargeBloc>(
      builder: (_) => FeedDischargeBloc(mixin: this),
      dispose: (_, value) => value.dispose(),
      child: Scaffold(
        appBar: AppBar(title: Text(Strings.newFeedDischarge)),
        body: Text("asas"),
      ),
    );
  }
}

class FeedDischargeEntry extends StatefulWidget {
  @override
  _FeedDischargeEntryState createState() => _FeedDischargeEntryState();
}

class _FeedDischargeEntryState extends State<FeedDischargeEntry> {

  final _formKey = GlobalKey<FormState>();
  var recordDate = DateTime.now();
  final dateFormat = DateFormat('yyyy-MM-dd');

  final dateTec = TextEditingController();
  final truckNoTec = TextEditingController();


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
    final bloc = Provider.of<FeedDischargeBloc>(context);

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      controller: truckNoTec,
                      autofocus: true,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: Strings.truckNo,
                        prefixIcon: Icon(Icons.home),
                        contentPadding: EdgeInsets.all(16),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return Strings.msgCannotBlank;
                        }
                        if (int.tryParse(value) == null) {
                          return Strings.msgNumberOnly;
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: RaisedButton.icon(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        final recordDate = dateTec.text;
                        final truckNo = truckNoTec.text;

                        final cfFd = bloc.validateEntry(recordDate, truckNo);

                        if (cfFd != null) {
                          Navigator.pushNamed(
                            context,
                            FeedDischargeDetailScreen.route,
                            arguments: cfFd,
                          );
                        }
                      }
                    },
                    icon: Icon(Icons.save),
                    label: Text(Strings.save.toUpperCase())),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
