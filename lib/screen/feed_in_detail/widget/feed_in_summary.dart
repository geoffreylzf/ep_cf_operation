import 'package:ep_cf_operation/db/dao/temp_cf_feed_in_detail_dao.dart';
import 'package:ep_cf_operation/model/table/cf_feed_in.dart';
import 'package:ep_cf_operation/res/string.dart';
import 'package:ep_cf_operation/screen/feed_in_detail/feed_in_detail_bloc.dart';
import 'package:ep_cf_operation/widget/simple_confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedInSummary extends StatefulWidget {
  @override
  _FeedInSummaryState createState() => _FeedInSummaryState();
}

class _FeedInSummaryState extends State<FeedInSummary> {
  @override
  Widget build(BuildContext mainContext) {
    final bloc = Provider.of<FeedInDetailBloc>(mainContext);
    return Column(
      children: [
        StreamBuilder<CfFeedIn>(
            stream: bloc.cfFeedInStream,
            builder: (context, snapshot) {
              var date = "";
              var docNo = "";
              var truckNo = "";
              if (snapshot.hasData) {
                date = snapshot.data.recordDate;
                docNo = snapshot.data.docNo.toString();
                truckNo = snapshot.data.truckNo.toString();
              }
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Date: $date", style: TextStyle(fontSize: 10)),
                    Text("Doc No: $docNo", style: TextStyle(fontSize: 10)),
                    Text("Truck No: $truckNo", style: TextStyle(fontSize: 10)),
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
                Expanded(flex: 5, child: ListHeader(Strings.feed)),
                Expanded(flex: 1, child: ListHeader(Strings.compartment_short)),
                Expanded(flex: 2, child: ListHeader(Strings.qty)),
                Expanded(flex: 1, child: Container()),
              ],
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<List<TempCfFeedInDetailWithInfo>>(
            stream: bloc.tempListStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              final list = snapshot.data;
              return ListView.builder(
                itemCount: list.length,
                itemBuilder: (ctx, position) {
                  final no = list.length - position;
                  final temp = list[position];

                  return Dismissible(
                    direction: DismissDirection.endToStart,
                    key: PageStorageKey(list[position].id.toString()),
                    onDismissed: (direction) async {
                      await bloc.deleteDetail(list[position].id);
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
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Text(
                                    "Feed : ${temp.skuName ?? "New Item (${temp.itemPackingId})"}",
                                    maxLines: 2,
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                                Text("Qty : ${temp.qty}"),
                                Text("Weight : ${temp.weight} Kg"),
                                Text("Compartment : ${temp.compartmentNo ?? ""}"),
                                Text("House : #${temp.houseNo}"),
                              ],
                            ),
                            actions: [
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
                        },
                      );
                    },
                    child: ExpansionTile(
                      backgroundColor: Theme.of(ctx).highlightColor,
                      title: Container(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                no.toString(),
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    temp.skuName ?? "New Item (${temp.itemPackingId})",
                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    temp.skuCode ?? "",
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                temp.compartmentNo ?? "",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                temp.qty.toString(),
                                textAlign: TextAlign.right,
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "House # ${temp.houseNo}",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "Weight ${temp.weight.toString()} Kg",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
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
                            await bloc.saveFeedIn();
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
