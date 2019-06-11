import 'package:ep_cf_operation/model/table/cf_weight.dart';
import 'package:ep_cf_operation/screen/weight_history/weight_history_bloc.dart';
import 'package:ep_cf_operation/screen/weight_view/weight_view_screen.dart';
import 'package:ep_cf_operation/util/date_time_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FrontPanel extends StatefulWidget {
  @override
  _FrontPanelState createState() => _FrontPanelState();
}

class _FrontPanelState extends State<FrontPanel> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<WeightHistoryBloc>(context);
    bloc.loadWeightList();
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () async {
        await bloc.refreshWeight(true);
      },
      child: StreamBuilder<List<CfWeight>>(
        stream: bloc.cfWeightListStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return HistoryList(snapshot.data);
        },
      ),
    );
  }
}

class HistoryList extends StatefulWidget {
  final List<CfWeight> cfWeightList;

  HistoryList(this.cfWeightList);

  @override
  _HistoryListState createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  @override
  Widget build(BuildContext context) {
    if (widget.cfWeightList.length == 0) {
      return ListView(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.blueGrey,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(Icons.info_outline, color: Colors.white, size: 16),
                  ),
                  Container(width: 4),
                  Text(
                    "No weight history found.",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          LoadMoreButton(),
        ],
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      itemCount: widget.cfWeightList.length + 1,
      separatorBuilder: (ctx, index) {
        return Divider(
          height: 0,
        );
      },
      itemBuilder: (ctx, index) {
        if (index == widget.cfWeightList.length) {
          return LoadMoreButton();
        }
        final cfWeight = widget.cfWeightList[index];
        var rowColor = Theme.of(context).scaffoldBackgroundColor;
        if (index % 2 == 0) {
          rowColor = Theme.of(context).primaryColorLight;
        }
        return Container(
          color: rowColor,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: InkWell(
            onTap: (){
              Navigator.pushNamed(
                context,
                WeightViewScreen.route,
                arguments: cfWeight.id,
              );
            },
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: [
                          TextSpan(text: "House ", style: TextStyle(fontSize: 10)),
                          TextSpan(
                              text: "#${cfWeight.houseNo.toString()}",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: Icon(Icons.date_range, size: 12),
                        ),
                        Text(DateTimeUtil().getDisplayDate(cfWeight.recordDate),
                            style: TextStyle(fontSize: 9)),
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: RichText(
                    textAlign: TextAlign.end,
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: [
                        TextSpan(text: " Day  ", style: TextStyle(fontSize: 10)),
                        TextSpan(
                            text: cfWeight.day.toString(),
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: cfWeight.isUploaded()
                      ? Icon(
                          Icons.cloud_upload,
                          size: 12,
                        )
                      : Container(width: 12),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class LoadMoreButton extends StatefulWidget {
  @override
  _LoadMoreButtonState createState() => _LoadMoreButtonState();
}

class _LoadMoreButtonState extends State<LoadMoreButton> {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<WeightHistoryBloc>(context);
    return StreamBuilder<bool>(
      stream: bloc.isRefreshableStream,
      initialData: false,
      builder: (context, snapshot) {
        if (snapshot.data) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 64, top: 4, left: 8, right: 8),
            child: OutlineButton.icon(
              icon: StreamBuilder<bool>(
                  stream: bloc.isRefreshLoadingStream,
                  initialData: false,
                  builder: (context, snapshot) {
                    if (!snapshot.data) {
                      return Icon(Icons.file_download);
                    }
                    return Padding(
                      padding: const EdgeInsets.all(4),
                      child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator()),
                    );
                  }),
              label: StreamBuilder<String>(
                  stream: bloc.refreshTextStream,
                  builder: (context, snapshot) {
                    var text = "";
                    if (snapshot.hasData) {
                      text = snapshot.data;
                    }
                    return Text(text);
                  }),
              onPressed: () {
                bloc.refreshWeight(false);
              },
            ),
          );
        }
        return Container();
      },
    );
  }
}
