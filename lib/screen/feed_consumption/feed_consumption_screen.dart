import 'package:ep_cf_operation/mixin/simple_alert_dialog_mixin.dart';
import 'package:ep_cf_operation/model/table/branch.dart';
import 'package:ep_cf_operation/model/table/cf_feed_consumption.dart';
import 'package:ep_cf_operation/res/string.dart';
import 'package:ep_cf_operation/screen/feed_consumption/feed_consumption_bloc.dart';
import 'package:ep_cf_operation/screen/feed_consumption_history/feed_consumption_history_screen.dart';
import 'package:ep_cf_operation/util/node_util.dart';
import 'package:ep_cf_operation/widget/form.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FeedConsumptionScreen extends StatefulWidget {
  static const String route = '/feedConsumption';

  @override
  _FeedConsumptionScreenState createState() => _FeedConsumptionScreenState();
}

class _FeedConsumptionScreenState extends State<FeedConsumptionScreen> with SimpleAlertDialogMixin {
  @override
  Widget build(BuildContext context) {
    return Provider<FeedConsumptionBloc>(
      builder: (_) => FeedConsumptionBloc(mixin: this),
      dispose: (_, value) => value.dispose(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(Strings.newFeedConsumption),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.history),
              onPressed: () => Navigator.pushNamed(context, FeedConsumptionHistoryScreen.route),
            ),
          ],
        ),
        body: FeedConsumptionEntry(),
      ),
    );
  }
}

class FeedConsumptionEntry extends StatefulWidget {
  @override
  _FeedConsumptionEntryState createState() => _FeedConsumptionEntryState();
}

class _FeedConsumptionEntryState extends State<FeedConsumptionEntry> {
  final _formKey = GlobalKey<FormState>();
  final dateFormat = DateFormat('yyyy-MM-dd');
  final dateTec = TextEditingController();
  final houseTec = TextEditingController();
  final bagTec = TextEditingController();
  final weightTec = TextEditingController();

  var recordDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    dateTec.text = dateFormat.format(recordDate);

    bagTec.addListener(() {
      final bag = double.tryParse(bagTec.text);
      if (bag != null) {
        weightTec.text = (bag * 50).toString();
      }
    });
  }

  @override
  void dispose() {
    dateTec.dispose();
    houseTec.dispose();
    bagTec.dispose();
    weightTec.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<FeedConsumptionBloc>(context);
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(children: [
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: TextField(
                  controller: dateTec,
                  enableInteractiveSelection: false,
                  focusNode: AlwaysDisabledFocusNode(),
                  onTap: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: recordDate,
                      firstDate: DateTime.now().add(Duration(days: -1)),
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
              ),
              Container(
                width: 8,
              ),
              Expanded(
                child: TextFormField(
                  controller: houseTec,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: Strings.houseNo,
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
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FormItemTitle("Feed Type"),
                      StreamBuilder<ItemTypeCode>(
                          stream: bloc.itemTypeCodeStream,
                          builder: (context, snapshot) {
                            return DropdownButton(
                              hint: Text("Feed Type"),
                              isExpanded: true,
                              elevation: 16,
                              value: snapshot.data,
                              onChanged: (v) {
                                bloc.setItemTypeCode(v);
                              },
                              items: itemTypeCodeList.map(
                                (r) {
                                  return DropdownMenuItem(
                                    value: r,
                                    child: Text(r.name),
                                  );
                                },
                              ).toList(),
                            );
                          })
                    ],
                  ),
                ),
                Container(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: bagTec,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Bag",
                      prefixIcon: Icon(FontAwesomeIcons.shoppingBag),
                      contentPadding: EdgeInsets.all(16),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return Strings.msgCannotBlank;
                      }
                      if (double.tryParse(value) == null) {
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
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: Container(),
                ),
                Container(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: weightTec,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Weight (kg)",
                      prefixIcon: Icon(FontAwesomeIcons.weight),
                      contentPadding: EdgeInsets.all(16),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return Strings.msgCannotBlank;
                      }
                      if (double.tryParse(value) == null) {
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
                      if (await bloc.saveFeedConsumption(
                        recordDate: dateTec.text,
                        houseNo: int.tryParse(houseTec.text),
                        weight: double.tryParse(weightTec.text),
                      )) {
                        Navigator.pop(context);
                      }
                    }
                  },
                  icon: Icon(Icons.save),
                  label: Text(Strings.save.toUpperCase())),
            ),
          ),
        ]),
      ),
    );
  }
}
