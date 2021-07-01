import 'package:ep_cf_operation/res/string.dart';
import 'package:ep_cf_operation/screen/feed_consumption_history/feed_consumption_history_bloc.dart';
import 'package:ep_cf_operation/widget/date_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BackPanel extends StatefulWidget {
  BackPanel({@required this.frontPanelOpen});

  final ValueNotifier<bool> frontPanelOpen;

  @override
  createState() => _BackPanelState();
}

class _BackPanelState extends State<BackPanel> {
  var houseTec = TextEditingController();
  var startDateTec = TextEditingController();
  var endDateTec = TextEditingController();

  @override
  void dispose() {
    houseTec.dispose();
    startDateTec.dispose();
    endDateTec.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<FeedConsumptionHistoryBloc>(context);
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
                Strings.msgFilterMortalityHistory,
                style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: houseTec,
              style: TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                prefixIcon: Icon(Icons.home, color: Colors.white),
                labelText: Strings.houseNo,
                contentPadding: const EdgeInsets.all(12),
                labelStyle: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: Row(
              children: <Widget>[
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
                  bloc.filterFeedConsumptionList(
                    int.tryParse(houseTec.text),
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
* Drag row of list from LEFT to RIGHT to delete
              """,
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }
}
