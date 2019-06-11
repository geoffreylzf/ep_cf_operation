import 'package:ep_cf_operation/mixin/simple_alert_dialog_mixin.dart';
import 'package:ep_cf_operation/model/table/cf_weight.dart';
import 'package:ep_cf_operation/res/string.dart';
import 'package:ep_cf_operation/screen/weight_detail/weight_detail_bloc.dart';
import 'package:ep_cf_operation/screen/weight_detail/widget/detail_entry.dart';
import 'package:ep_cf_operation/screen/weight_detail/widget/temp_list.dart';
import 'package:ep_cf_operation/screen/weight_detail/widget/weight_summary.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WeightDetailScreen extends StatefulWidget {
  static const String route = '/weightDetail';
  final CfWeight cfWeight;

  WeightDetailScreen(this.cfWeight);

  @override
  _WeightDetailScreenState createState() => _WeightDetailScreenState();
}

class _WeightDetailScreenState extends State<WeightDetailScreen>
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
    return MultiProvider(
      providers: [
        Provider<WeightDetailBloc>(
          builder: (_) => WeightDetailBloc(mixin: this, cfWeight: widget.cfWeight),
          dispose: (_, value) => value.dispose(),
        ),
      ],
      child: WillPopScope(
        onWillPop: () => _onBackPressed(context),
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(70),
            child: AppBar(
              title: Text(Strings.newBodyWeightDetail, style: TextStyle(fontSize: 16)),
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
              Row(
                children: [
                  Expanded(flex: 4, child: TempList()),
                  VerticalDivider(width: 0),
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DetailEntry(),
                    ),
                  ),
                ],
              ),
              WeightSummary(),
            ],
          ),
        ),
      ),
    );
  }
}

Future<bool> _onBackPressed(BuildContext context) {
  return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Back to new weight?'),
              content: Text('Unsaved data will be discard...'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: new Text(Strings.cancel.toUpperCase()),
                ),
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(Strings.back.toUpperCase()),
                ),
              ],
            );
          }) ??
      false;
}
