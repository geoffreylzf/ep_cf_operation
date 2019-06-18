import 'package:ep_cf_operation/model/table/cf_feed_in.dart';
import 'package:ep_cf_operation/screen/feed_in_history/feed_in_history_bloc.dart';
import 'package:ep_cf_operation/screen/feed_in_view/feed_in_view_screen.dart';
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
    final bloc = Provider.of<FeedInHistoryBloc>(context);
    bloc.loadFeedInList();
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () async {
        await bloc.refreshFeedIn(true);
      },
      child: StreamBuilder<List<CfFeedIn>>(
        stream: bloc.cfFeedInListStream,
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
  final List<CfFeedIn> cfFeedInList;

  HistoryList(this.cfFeedInList);

  @override
  _HistoryListState createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  @override
  Widget build(BuildContext context) {
    if (widget.cfFeedInList.length == 0) {
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
                    "No feed in history found.",
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
      itemCount: widget.cfFeedInList.length + 1,
      separatorBuilder: (ctx, index) {
        return Divider(
          height: 0,
        );
      },
      itemBuilder: (ctx, index) {
        if (index == widget.cfFeedInList.length) {
          return LoadMoreButton();
        }
        final cfFeedIn = widget.cfFeedInList[index];
        var rowColor = Theme.of(context).scaffoldBackgroundColor;
        if (index % 2 == 0) {
          rowColor = Theme.of(context).primaryColorLight;
        }
        return Container(
          color: rowColor,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, FeedInViewScreen.route, arguments: cfFeedIn.id);
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
                          TextSpan(text: "Doc No ", style: TextStyle(fontSize: 10)),
                          TextSpan(
                              text: "${cfFeedIn.docNo.toString()}",
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
                        Text(DateTimeUtil().getDisplayDate(cfFeedIn.recordDate),
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
                        TextSpan(text: " Truck No  ", style: TextStyle(fontSize: 10)),
                        TextSpan(
                            text: cfFeedIn.truckNo.toString(),
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: cfFeedIn.isUploaded()
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
    final bloc = Provider.of<FeedInHistoryBloc>(context);
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
                bloc.refreshFeedIn(false);
              },
            ),
          );
        }
        return Container();
      },
    );
  }
}

