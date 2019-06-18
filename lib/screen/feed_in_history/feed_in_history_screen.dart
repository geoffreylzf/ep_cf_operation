import 'package:ep_cf_operation/res/string.dart';
import 'package:ep_cf_operation/screen/feed_in_history/feed_in_history_bloc.dart';
import 'package:ep_cf_operation/screen/feed_in_history/widget/back_panel.dart';
import 'package:ep_cf_operation/screen/feed_in_history/widget/front_panel.dart';
import 'package:ep_cf_operation/screen/feed_in_history/widget/front_panel_title.dart';
import 'package:ep_cf_operation/widget/backdrop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedInHistoryScreen extends StatefulWidget {
  static const String route = '/feedInHistory';

  @override
  _FeedInHistoryScreenState createState() => _FeedInHistoryScreenState();
}

class _FeedInHistoryScreenState extends State<FeedInHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Provider<FeedInHistoryBloc>(
      builder: (_) => FeedInHistoryBloc(context: context),
      dispose: (_, value) => value.dispose(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(Strings.feedInHistory),
        ),
        body: SafeArea(child: Panels()),
      ),
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