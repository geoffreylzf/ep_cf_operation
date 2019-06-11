import 'package:ep_cf_operation/res/string.dart';
import 'package:ep_cf_operation/screen/weight_history/weight_history_bloc.dart';
import 'package:ep_cf_operation/widget/date_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BackPanel extends StatefulWidget {
  final ValueNotifier<bool> frontPanelOpen;

  BackPanel({@required this.frontPanelOpen});

  @override
  _BackPanelState createState() => _BackPanelState();
}

class _BackPanelState extends State<BackPanel> {
  var houseTec = TextEditingController();
  var dayTec = TextEditingController();
  var startDateTec = TextEditingController();
  var endDateTec = TextEditingController();

  @override
  void dispose() {
    houseTec.dispose();
    dayTec.dispose();
    startDateTec.dispose();
    endDateTec.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<WeightHistoryBloc>(context);
    return Container(
      width: double.infinity,
      color: Theme.of(context).primaryColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                Strings.msgFilterBodyWeightHistory,
                style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: houseTec,
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      enabledBorder:
                          OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      focusedBorder:
                          OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      prefixIcon: Icon(Icons.home, color: Colors.white),
                      labelText: Strings.houseNo,
                      contentPadding: const EdgeInsets.all(12),
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Container(width: 8),
                Expanded(
                  child: TextField(
                    controller: dayTec,
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      enabledBorder:
                          OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      focusedBorder:
                          OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      prefixIcon: Icon(Icons.today, color: Colors.white),
                      labelText: Strings.day,
                      contentPadding: const EdgeInsets.all(12),
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: Row(
              children: [
                Expanded(
                  child: DateTextField(Strings.startDate, startDateTec),
                ),
                Container(width: 8),
                Expanded(
                  child: DateTextField(Strings.endDate, endDateTec),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              RaisedButton.icon(
                icon: Icon(Icons.refresh, color: Colors.white),
                label: Text(Strings.clear.toUpperCase(), style: TextStyle(color: Colors.white)),
                color: Theme.of(context).primaryColorDark,
                onPressed: () {
                  houseTec.text = "";
                  dayTec.text = "";
                  startDateTec.text = "";
                  endDateTec.text = "";
                },
              ),
              RaisedButton.icon(
                icon: Icon(Icons.search, color: Theme.of(context).primaryColor),
                label: Text(
                  Strings.search.toUpperCase(),
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                color: Colors.white,
                onPressed: () async {
                  bloc.filterWeightList(
                    int.tryParse(houseTec.text),
                    int.tryParse(dayTec.text),
                    startDateTec.text,
                    endDateTec.text,
                  );
                  FocusScope.of(context).requestFocus(new FocusNode());
                  widget.frontPanelOpen.value = true;
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              """* Drag the list from TOP to BOTTOM to refresh
* Tap the row to open detail screen
              """,
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }
}
