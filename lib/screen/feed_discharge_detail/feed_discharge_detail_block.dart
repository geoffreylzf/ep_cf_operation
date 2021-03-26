import 'package:ep_cf_operation/mixin/simple_alert_dialog_mixin.dart';
import 'package:flutter/material.dart';

class FeedDischargeDetailScreen extends StatefulWidget {
  static const String route = '/feedDischargeDetail';

  @override
  _FeedDischargeDetailScreenState createState() => _FeedDischargeDetailScreenState();
}

class _FeedDischargeDetailScreenState extends State<FeedDischargeDetailScreen>
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
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
