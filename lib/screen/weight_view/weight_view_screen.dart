import 'package:ep_cf_operation/model/table/cf_weight.dart';
import 'package:ep_cf_operation/model/table/cf_weight_detail.dart';
import 'package:ep_cf_operation/res/string.dart';
import 'package:ep_cf_operation/screen/weight_view/weight_view_bloc.dart';
import 'package:ep_cf_operation/util/date_time_util.dart';
import 'package:ep_cf_operation/widget/simple_alert_dialog.dart';
import 'package:ep_cf_operation/widget/simple_confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WeightViewScreen extends StatefulWidget {
  static const String route = '/weightView';

  final int cfWeightId;

  WeightViewScreen(this.cfWeightId);

  @override
  _WeightViewScreenState createState() => _WeightViewScreenState();
}

class _WeightViewScreenState extends State<WeightViewScreen> {
  WeightViewBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = WeightViewBloc(cfWeightId: widget.cfWeightId);
  }

  @override
  Widget build(BuildContext context) {
    return Provider<WeightViewBloc>(
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
        final cfWeight = bloc.getCfWeight();
        final dayDif =
            DateTime.now().difference(DateTimeUtil().getDate(cfWeight.recordDate)).inDays;

        if (cfWeight.isDeleted()) {
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
              bloc.deleteCfWeight();
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
    final bloc = Provider.of<WeightViewBloc>(context);
    return StreamBuilder<CfWeight>(
        stream: bloc.cfWeightStream,
        builder: (context, snapshot) {
          var houseNo = "";
          var day = "";
          var date = "";
          var time = "";
          var isDeleted = false;

          if (snapshot.hasData) {
            final cfWeight = snapshot.data;
            houseNo = cfWeight.houseNo.toString();
            day = cfWeight.day.toString();
            date = cfWeight.recordDate;
            time = cfWeight.recordTime;
            isDeleted = cfWeight.isDeleted();
          }
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("House : $houseNo", style: TextStyle(fontSize: 12)),
                    Text("Day : $day", style: TextStyle(fontSize: 12)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Date : $date", style: TextStyle(fontSize: 12)),
                    Text("Time : $time", style: TextStyle(fontSize: 12)),
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
    final bloc = Provider.of<WeightViewBloc>(context);
    return Column(
      children: [
        Container(
          color: Theme.of(context).primaryColorDark,
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
          child: StreamBuilder<List<CfWeightDetail>>(
              stream: bloc.cfWeightDetailListStream,
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
                                flex: 1, child: Text(no.toString(), textAlign: TextAlign.center)),
                            Expanded(
                                flex: 2,
                                child: Text(temp.section.toString(), textAlign: TextAlign.center)),
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
                    );
                  },
                );
              }),
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
