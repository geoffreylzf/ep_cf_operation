import 'package:ep_cf_operation/db/dao/cf_feed_in_detail_dao.dart';
import 'package:ep_cf_operation/model/table/cf_feed_in.dart';
import 'package:ep_cf_operation/model/table/cf_feed_in_detail.dart';
import 'package:ep_cf_operation/res/string.dart';
import 'package:ep_cf_operation/screen/feed_in_view/feed_in_view_bloc.dart';
import 'package:ep_cf_operation/util/date_time_util.dart';
import 'package:ep_cf_operation/widget/simple_alert_dialog.dart';
import 'package:ep_cf_operation/widget/simple_confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedInViewScreen extends StatefulWidget {
  static const String route = '/feedInView';

  final int cfFeedInId;

  FeedInViewScreen(this.cfFeedInId);

  @override
  _FeedInViewScreenState createState() => _FeedInViewScreenState();
}

class _FeedInViewScreenState extends State<FeedInViewScreen> {
  FeedInViewBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = FeedInViewBloc(cfFeedInId: widget.cfFeedInId);
  }

  @override
  Widget build(BuildContext context) {
    return Provider<FeedInViewBloc>(
      builder: (_) => bloc,
      dispose: (_, value) => value.dispose(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(Strings.bodyWeightView),
          actions: [
            PopupMenuButton(
              onSelected: (v) {
                _deleteCfWeight();
              },
              itemBuilder: (ctx) {
                return [
                  PopupMenuItem(
                    value: 1,
                    child: Text(Strings.delete),
                  )
                ];
              },
            )
          ],
        ),
        body: Column(
          children: [
            Header(),
            Expanded(child: Info()),
          ],
        ),
      ),
    );
  }

  _deleteCfWeight() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final cfFeedIn = bloc.getCfFeedIn();
        final dayDif =
            DateTime.now().difference(DateTimeUtil().getDate(cfFeedIn.recordDate)).inDays;

        if (cfFeedIn.isDeleted()) {
          return SimpleAlertDialog(
            title: Strings.error,
            message: "Data already deleted",
          );
        } else if (dayDif > 7) {
          return SimpleAlertDialog(
            title: Strings.error,
            message: "Data record date more than 7 days is undeletable ($dayDif Days)",
          );
        } else {
          return SimpleConfirmDialog(
            title: "Delete?",
            message: "Delete will be completed after upload",
            btnPositiveText: Strings.delete,
            vcb: () {
              bloc.deleteCfFeedIn();
            },
          );
        }
      },
    );
  }
}

class Header extends StatefulWidget {
  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<FeedInViewBloc>(context);
    return StreamBuilder<CfFeedIn>(
        stream: bloc.cfFeedInStream,
        builder: (context, snapshot) {
          var date = "";
          var docNo = "";
          var truckNo = "";
          var isDeleted = false;

          if (snapshot.hasData) {
            final cfFeedIn = snapshot.data;
            date = cfFeedIn.recordDate;
            docNo = cfFeedIn.docNo;
            truckNo = cfFeedIn.truckNo;
            isDeleted = cfFeedIn.isDeleted();
          }
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Date : $date", style: TextStyle(fontSize: 12)),
                    Text("Doc No : $docNo", style: TextStyle(fontSize: 12)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Truck No : $truckNo", style: TextStyle(fontSize: 12)),
                    if (isDeleted) Text("(Deleted)"),
                  ],
                ),
              ],
            ),
          );
        });
  }
}

class Info extends StatefulWidget {
  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<FeedInViewBloc>(context);
    return Column(
      children: [
        Container(
          color: Theme.of(context).primaryColorDark,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                Expanded(flex: 1, child: ListHeader("#")),
                Expanded(flex: 1, child: ListHeader(Strings.house_short)),
                Expanded(flex: 3, child: ListHeader(Strings.feed)),
                Expanded(flex: 1, child: ListHeader(Strings.compartment_short)),
                Expanded(flex: 2, child: ListHeader(Strings.weight)),
              ],
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<List<CfFeedInDetailWithInfo>>(
            stream: bloc.cfFeedInDetailListStream,
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
                    bgColor = Theme.of(ctx).primaryColorLight;
                  }

                  return Container(
                    color: bgColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: Text(
                                no.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12),
                              )),
                          Expanded(
                              flex: 1,
                              child: Text(
                                temp.houseNo.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12),
                              )),
                          Expanded(
                              flex: 3,
                              child: Text(
                                temp.skuName ?? "ITEM ID : ${temp.itemPackingId}",
                                style: TextStyle(fontSize: 10),
                              )),
                          Expanded(
                              flex: 1,
                              child: Text(
                                temp.compartmentNo ?? "",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12),
                              )),
                          Expanded(
                              flex: 2,
                              child: Text(
                                temp.weight.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12),
                              )),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
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
