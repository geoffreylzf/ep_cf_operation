import 'package:ep_cf_operation/mixin/simple_alert_dialog_mixin.dart';
import 'package:ep_cf_operation/model/feed_in_qr.dart';
import 'package:ep_cf_operation/model/table/cf_feed_in.dart';
import 'package:ep_cf_operation/res/string.dart';
import 'package:flutter/material.dart';

class FeedInDetailScreenArguments {
  final CfFeedIn cfFeedIn;
  final FeedInQr feedInQr;

  FeedInDetailScreenArguments(this.cfFeedIn, this.feedInQr);
}

class FeedInDetailScreen extends StatefulWidget {
  static const String route = '/feedInDetail';
  final FeedInDetailScreenArguments arguments;

  FeedInDetailScreen(this.arguments);

  @override
  _FeedInDetailScreenState createState() => _FeedInDetailScreenState();
}

class _FeedInDetailScreenState extends State<FeedInDetailScreen>
    with SimpleAlertDialogMixin, SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging && _tabController.index == 1) {
        //Dismiss keyboard
        FocusScope.of(context).requestFocus(new FocusNode());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          title: Text(Strings.newFeedInDetail, style: TextStyle(fontSize: 16)),
          centerTitle: true,
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Container(height: 28, child: Tab(icon: Icon(Icons.view_list, size: 16))),
              Container(height: 28, child: Tab(icon: Icon(Icons.save, size: 16))),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Container(),
          Container(),
        ],
      ),
    );
  }
}
