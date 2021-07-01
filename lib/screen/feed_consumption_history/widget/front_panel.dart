import 'package:ep_cf_operation/model/table/cf_feed_consumption.dart';
import 'package:ep_cf_operation/res/string.dart';
import 'package:ep_cf_operation/screen/feed_consumption_history/feed_consumption_history_bloc.dart';
import 'package:ep_cf_operation/util/date_time_util.dart';
import 'package:ep_cf_operation/widget/simple_alert_dialog.dart';
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
    final bloc = Provider.of<FeedConsumptionHistoryBloc>(context);
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () async {
        await bloc.refreshFeedConsumption(true);
      },
      child: StreamBuilder<List<CfFeedConsumption>>(
        stream: bloc.cfFeedConsumptionListStream,
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
  final List<CfFeedConsumption> cfFeedConsumptionList;

  HistoryList(this.cfFeedConsumptionList);

  @override
  _HistoryListState createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<FeedConsumptionHistoryBloc>(context);

    if (widget.cfFeedConsumptionList.length == 0) {
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
                    "No feed consumption history found.",
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
      itemCount: widget.cfFeedConsumptionList.length + 1,
      separatorBuilder: (ctx, index) {
        return Divider(
          height: 0,
        );
      },
      itemBuilder: (ctx, index) {
        if (index == widget.cfFeedConsumptionList.length) {
          return LoadMoreButton();
        }
        final cfFeedConsumption = widget.cfFeedConsumptionList[index];
        return Dismissible(
          key: PageStorageKey(cfFeedConsumption.id.toString()),
          onDismissed: (direction) {
            bloc.deleteFeedConsumption(cfFeedConsumption.id);
          },
          background: Container(
            child: Icon(
              Icons.delete_outline,
            ),
          ),
          confirmDismiss: (direction) async {
            final dayDif = DateTime.now()
                .difference(DateTimeUtil().getDate(cfFeedConsumption.recordDate))
                .inDays;

            if (dayDif > 7) {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("Data record date more than 7 days is undeletable ($dayDif Days)"),
              ));
              return false;
            }

            return await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Delete this feed consumption data?"),
                    content: Text("""
${Strings.houseNo} : ${cfFeedConsumption.houseNo}
${Strings.recordDate} : ${cfFeedConsumption.recordDate}
${Strings.feedType} : ${(cfFeedConsumption.getItemTypeCodeName())}
${Strings.bag} : ${cfFeedConsumption.getBag().toStringAsFixed(3)} 
${Strings.weightKg} : ${cfFeedConsumption.weight.toStringAsFixed(3)} 
                                  """),
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
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            color: DateTimeUtil().getWeekColor(cfFeedConsumption.recordDate),
            child: InkWell(
              onTap: () {},
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
                                text: "#${cfFeedConsumption.houseNo.toString()}",
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
                          Text(DateTimeUtil().getDisplayDate(cfFeedConsumption.recordDate),
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
                          TextSpan(
                            text: cfFeedConsumption.getItemTypeCodeName() + " ",
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                              text: cfFeedConsumption.getBag().toStringAsFixed(3),
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          TextSpan(text: " Bag  ", style: TextStyle(fontSize: 10)),
                          TextSpan(
                              text: cfFeedConsumption.weight.toStringAsFixed(3),
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          TextSpan(text: " Kg ", style: TextStyle(fontSize: 10)),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: cfFeedConsumption.isUploaded()
                        ? Icon(
                            Icons.cloud_upload,
                            size: 12,
                          )
                        : Container(width: 12),
                  ),
                ],
              ),
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
    final bloc = Provider.of<FeedConsumptionHistoryBloc>(context);
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
                bloc.refreshFeedConsumption(false);
              },
            ),
          );
        }
        return Container();
      },
    );
  }
}
