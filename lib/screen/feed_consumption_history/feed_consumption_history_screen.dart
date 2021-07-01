import 'package:ep_cf_operation/res/string.dart';
import 'package:ep_cf_operation/screen/feed_consumption_history/feed_consumption_history_bloc.dart';
import 'package:ep_cf_operation/screen/feed_consumption_history/widget/back_panel.dart';
import 'package:ep_cf_operation/screen/feed_consumption_history/widget/front_panel.dart';
import 'package:ep_cf_operation/screen/feed_consumption_history/widget/front_panel_title.dart';
import 'package:ep_cf_operation/widget/backdrop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedConsumptionHistoryScreen extends StatefulWidget {
  static const String route = '/feedConsumptionHistory';

  @override
  _FeedConsumptionHistoryScreenState createState() => _FeedConsumptionHistoryScreenState();
}

class _FeedConsumptionHistoryScreenState extends State<FeedConsumptionHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Provider<FeedConsumptionHistoryBloc>(
      builder: (_) => FeedConsumptionHistoryBloc(context: context),
      dispose: (_, value) => value.dispose(),
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text(Strings.feedConsumptionHistory),
          ),
          body: SafeArea(child: Panels())),
    );
  }
}

class Panels extends StatefulWidget {
  @override
  _PanelsState createState() => _PanelsState();
}

class _PanelsState extends State<Panels> {
  final frontPanelVisible = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    return Backdrop(
      frontLayer: FrontPanel(),
      backLayer: BackPanel(
        frontPanelOpen: frontPanelVisible,
      ),
      frontHeader: FrontPanelTitle(),
      panelVisible: frontPanelVisible,
      frontHeaderHeight: 48.0,
      frontHeaderVisibleClosed: true,
    );
  }
}
