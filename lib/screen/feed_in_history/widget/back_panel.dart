import 'package:ep_cf_operation/res/string.dart';
import 'package:ep_cf_operation/screen/feed_in_history/feed_in_history_bloc.dart';
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
  final startDateTec = TextEditingController();
  final endDateTec = TextEditingController();
  final docNoTec = TextEditingController();
  final truckNoTec = TextEditingController();

  @override
  void dispose() {
    startDateTec.dispose();
    endDateTec.dispose();
    docNoTec.dispose();
    truckNoTec.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<FeedInHistoryBloc>(context);
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
                Strings.msgFilterFeedInHistory,
                style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              ),
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
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: docNoTec,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      enabledBorder:
                          OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      focusedBorder:
                          OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      prefixIcon: Icon(Icons.home, color: Colors.white),
                      labelText: Strings.docNo,
                      contentPadding: const EdgeInsets.all(12),
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Container(width: 8),
                Expanded(
                  child: TextField(
                    controller: truckNoTec,
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      enabledBorder:
                          OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      focusedBorder:
                          OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      prefixIcon: Icon(Icons.today, color: Colors.white),
                      labelText: Strings.truckNo,
                      contentPadding: const EdgeInsets.all(12),
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                  ),
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
                  startDateTec.text = "";
                  endDateTec.text = "";
                  docNoTec.text = "";
                  truckNoTec.text = "";
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
                    startDateTec.text,
                    endDateTec.text,
                    docNoTec.text,
                    truckNoTec.text,
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
