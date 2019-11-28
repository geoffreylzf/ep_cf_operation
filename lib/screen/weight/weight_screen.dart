import 'package:ep_cf_operation/mixin/simple_alert_dialog_mixin.dart';
import 'package:ep_cf_operation/model/table/branch.dart';
import 'package:ep_cf_operation/res/string.dart';
import 'package:ep_cf_operation/screen/weight/weight_bloc.dart';
import 'package:ep_cf_operation/screen/weight_detail/weight_detail_screen.dart';
import 'package:ep_cf_operation/util/node_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WeightScreen extends StatefulWidget {
  static const String route = '/weight';

  @override
  _WeightScreenState createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> with SimpleAlertDialogMixin {
  @override
  Widget build(BuildContext context) {
    return Provider<WeightBloc>(
      builder: (_) => WeightBloc(mixin: this),
      dispose: (_, value) => value.dispose(),
      child: Scaffold(
        appBar: AppBar(title: Text(Strings.newBodyWeight)),
        body: WeightEntry(),
      ),
    );
  }
}

class WeightEntry extends StatefulWidget {
  @override
  _WeightEntryState createState() => _WeightEntryState();
}

class _WeightEntryState extends State<WeightEntry> {
  final _formKey = GlobalKey<FormState>();
  var recordDate = DateTime.now();
  var dateFormat = DateFormat('yyyy-MM-dd');

  var dateTec = TextEditingController();
  var houseTec = TextEditingController();
  var dayTec = TextEditingController();

  @override
  void initState() {
    super.initState();
    dateTec.text = dateFormat.format(recordDate);
  }

  @override
  void dispose() {
    dateTec.dispose();
    houseTec.dispose();
    dayTec.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<WeightBloc>(context);
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
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
                  Container(
                    width: 8,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: dayTec,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: Strings.day,
                        prefixIcon: Icon(FontAwesomeIcons.calendarDay),
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
                        final houseNo = int.tryParse(houseTec.text);
                        final day = int.tryParse(dayTec.text);

                        final cfWeight = bloc.validateEntry(recordDate, houseNo, day);

                        if (cfWeight != null) {
                          Navigator.pushNamed(
                            context,
                            WeightDetailScreen.route,
                            arguments: cfWeight,
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
