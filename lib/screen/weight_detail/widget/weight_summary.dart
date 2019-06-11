import 'package:ep_cf_operation/model/table/cf_weight.dart';
import 'package:ep_cf_operation/model/table/temp_cf_weight_detail.dart';
import 'package:ep_cf_operation/res/string.dart';
import 'package:ep_cf_operation/screen/weight_detail/weight_detail_bloc.dart';
import 'package:ep_cf_operation/widget/simple_confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WeightSummary extends StatefulWidget {
  @override
  _WeightSummaryState createState() => _WeightSummaryState();
}

class _WeightSummaryState extends State<WeightSummary> {
  @override
  Widget build(BuildContext mainContext) {
    final bloc = Provider.of<WeightDetailBloc>(mainContext);
    return Column(
      children: [
        StreamBuilder<CfWeight>(
            stream: bloc.cfWeightStream,
            builder: (context, snapshot) {
              var date = "";
              var house = "";
              var day = "";
              if (snapshot.hasData) {
                date = snapshot.data.recordDate;
                house = snapshot.data.houseNo.toString();
                day = snapshot.data.day.toString();
              }
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Date: $date", style: TextStyle(fontSize: 10)),
                    Text("House: $house", style: TextStyle(fontSize: 10)),
                    Text("Day: $day", style: TextStyle(fontSize: 10)),
                  ],
                ),
              );
            }),
        Container(
          color: Theme.of(mainContext).primaryColorDark,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                Expanded(flex: 1, child: ListHeader("#")),
                Expanded(flex: 2, child: ListHeader(Strings.section)),
                Expanded(flex: 2, child: ListHeader(Strings.gender)),
                Expanded(flex: 2, child: ListHeader(Strings.quantity)),
                Expanded(flex: 3, child: ListHeader(Strings.weightGram)),
              ],
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<List<TempCfWeightDetail>>(
              stream: bloc.tempListStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                var list = snapshot.data;
                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (ctx, position) {
                    var no = list.length - position;
                    var temp = list[position];
                    var bgColor = Theme.of(ctx).scaffoldBackgroundColor;

                    if (no % 2 == 0) {
                      bgColor = Theme.of(ctx).highlightColor;
                    }

                    return Dismissible(
                      direction: DismissDirection.endToStart,
                      key: PageStorageKey(list[position].id.toString()),
                      onDismissed: (direction) {
                        bloc.deleteDetail(list[position].id);
                      },
                      background: Container(
                        color: Colors.red,
                        child: Icon(
                          Icons.clear,
                          color: Colors.white,
                        ),
                      ),
                      confirmDismiss: (direction) async {
                        return await showDialog<bool>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Delete this data?"),
                                content: Text("Weight : ${temp.weight} gram"),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text(Strings.cancel.toUpperCase()),
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                  ),
                                  FlatButton(
                                    child: Text(Strings.delete.toUpperCase()),
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                    },
                                  ),
                                ],
                              );
                            });
                      },
                      child: Container(
                        color: bgColor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 1, child: Text(no.toString(), textAlign: TextAlign.center)),
                              Expanded(
                                  flex: 2,
                                  child:
                                      Text(temp.section.toString(), textAlign: TextAlign.center)),
                              Expanded(
                                  flex: 2, child: Text(temp.gender, textAlign: TextAlign.center)),
                              Expanded(
                                  flex: 2,
                                  child: Text(temp.qty.toString(), textAlign: TextAlign.center)),
                              Expanded(
                                  flex: 3,
                                  child: Text(temp.weight.toString(), textAlign: TextAlign.center)),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
        ),
        Container(
          padding: const EdgeInsets.all(4),
          child: Text(
            "Swipe left to delete",
            style: TextStyle(fontSize: 10),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: SizedBox(
            width: double.infinity,
            child: RaisedButton.icon(
              icon: Icon(Icons.save),
              label: Text(Strings.save.toUpperCase()),
              onPressed: () {
                bloc.validate().then((r) {
                  if (r) {
                    showDialog(
                      context: mainContext,
                      builder: (BuildContext context) {
                        return SimpleConfirmDialog(
                          title: "Save?",
                          message: "Edit is not allow after save.",
                          btnPositiveText: Strings.save,
                          vcb: () async {
                            await bloc.saveWeight();
                            Navigator.of(mainContext).pop();
                            Navigator.of(mainContext).pop();
                          },
                        );
                      },
                    );
                  }
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}

class ListHeader extends StatelessWidget {
  final String text;

  ListHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    );
  }
}
