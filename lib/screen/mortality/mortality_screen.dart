import 'package:ep_cf_operation/mixin/simple_alert_dialog_mixin.dart';
import 'package:ep_cf_operation/model/table/branch.dart';
import 'package:ep_cf_operation/repository/mortality_repository.dart';
import 'package:ep_cf_operation/res/string.dart';
import 'package:ep_cf_operation/screen/mortality/mortality_bloc.dart';
import 'package:ep_cf_operation/util/node_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MortalityScreen extends StatefulWidget {
  static const String route = '/mortality';

  @override
  _MortalityScreenState createState() => _MortalityScreenState();
}

class _MortalityScreenState extends State<MortalityScreen> with SimpleAlertDialogMixin {
  @override
  Widget build(BuildContext context) {
    return Provider<MortalityBloc>(
      builder: (_) => MortalityBloc(mixin: this),
      dispose: (_, value) => value.dispose(),
      child: Scaffold(
        appBar: AppBar(title: Text(Strings.mortality)),
        body: MortalityEntry(),
      ),
    );
  }
}

class MortalityEntry extends StatefulWidget {
  @override
  _MortalityEntryState createState() => _MortalityEntryState();
}

class _MortalityEntryState extends State<MortalityEntry> {
  final _formKey = GlobalKey<FormState>();
  var recordDate = DateTime.now();
  var dateFormat = DateFormat('yyyy-MM-dd');
  var dateTec = TextEditingController();
  var houseTec = TextEditingController();
  var mortalityTec = TextEditingController();
  var rejectTec = TextEditingController();

  @override
  void initState() {
    super.initState();
    dateTec.text = dateFormat.format(recordDate);
    _loadNewHouseNo();
  }

  _loadNewHouseNo() async {
    var newHouseNo = await MortalityRepository().getNewHouseNo(dateTec.text);
    houseTec.text = newHouseNo.toString();
  }

  @override
  void dispose() {
    dateTec.dispose();
    houseTec.dispose();
    mortalityTec.dispose();
    rejectTec.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<MortalityBloc>(context);
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
                        firstDate: DateTime.now().add(Duration(days: -7)),
                        lastDate: DateTime.now(),
                      );

                      if (selectedDate != null) {
                        recordDate = selectedDate;
                        dateTec.text = dateFormat.format(selectedDate);
                        _loadNewHouseNo();
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
                    child: TextFormField(
                      controller: mortalityTec,
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: Strings.dead,
                        prefixIcon: Icon(FontAwesomeIcons.skullCrossbones),
                        contentPadding: EdgeInsets.all(16),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return Strings.msgCannotBlank;
                        }
                        if (int.tryParse(value) == null) {
                          return Strings.msgNumberOnly;
                        }
                      },
                    ),
                  ),
                  Container(
                    width: 8,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: rejectTec,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: Strings.reject,
                        prefixIcon: Icon(FontAwesomeIcons.ban),
                        contentPadding: EdgeInsets.all(16),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return Strings.msgCannotBlank;
                        }
                        if (int.tryParse(value) == null) {
                          return Strings.msgNumberOnly;
                        }
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
                        if (await bloc.saveMortality(
                          recordDate: dateTec.text,
                          houseNo: int.tryParse(houseTec.text),
                          mQty: int.tryParse(mortalityTec.text),
                          rQty: int.tryParse(rejectTec.text),
                        )) {
                          Navigator.pop(context);
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
