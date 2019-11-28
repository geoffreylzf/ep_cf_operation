import 'package:ep_cf_operation/mixin/simple_alert_dialog_mixin.dart';
import 'package:ep_cf_operation/model/table/branch.dart';
import 'package:ep_cf_operation/res/nav.dart';
import 'package:ep_cf_operation/res/string.dart';
import 'package:ep_cf_operation/screen/home/bloc/home_bloc.dart';
import 'package:ep_cf_operation/screen/home/bloc/home_feed_bloc.dart';
import 'package:ep_cf_operation/screen/home/bloc/home_mortality_bloc.dart';
import 'package:ep_cf_operation/screen/home/bloc/home_weight_bloc.dart';
import 'package:ep_cf_operation/screen/home/widget/feed_dashboard.dart';
import 'package:ep_cf_operation/screen/home/widget/mortality_dashboard.dart';
import 'package:ep_cf_operation/screen/home/widget/weight_dashboard.dart';
import 'package:ep_cf_operation/screen/upload/upload_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const String route = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin, SimpleAlertDialogMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<HomeBloc>(
          builder: (_) => HomeBloc(),
          dispose: (_, value) => value.dispose(),
        ),
        Provider<HomeMortalityBloc>(
          builder: (_) => HomeMortalityBloc(),
          dispose: (_, value) => value.dispose(),
        ),
        Provider<HomeWeightBloc>(
          builder: (_) => HomeWeightBloc(mixin: this),
          dispose: (_, value) => value.dispose(),
        ),
        Provider<HomeFeedBloc>(
          builder: (_) => HomeFeedBloc(),
          dispose: (_, value) => value.dispose(),
        ),
      ],
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: AppBar(
            title: Text(
              Strings.contractFarmerOperation,
              style: TextStyle(fontSize: 16),
            ),
            centerTitle: true,
            bottom: TabBar(
              controller: _tabController,
              tabs: [
                Container(height: 28, child: Tab(icon: Icon(Icons.clear, size: 16))),
                Container(height: 28, child: Tab(icon: Icon(FontAwesomeIcons.weight, size: 16))),
                Container(height: 28, child: Tab(icon: Icon(FontAwesomeIcons.seedling, size: 16))),
              ],
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            MortalityDashboard(),
            WeightDashboard(),
            FeedDashboard(),
          ],
        ),
        bottomNavigationBar: BottomBar(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, UploadScreen.route);
          },
          child: Icon(Icons.cloud_upload),
        ),
        drawer: NavDrawerStart(),
      ),
    );
  }
}

class BottomBar extends StatefulWidget {
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<HomeBloc>(context);
    bloc.loadLocation();
    bloc.loadPendingUploadCount();
    return BottomAppBar(
      color: Theme.of(context).primaryColor,
      shape: CircularNotchedRectangle(),
      notchMargin: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Row(
              children: [
                Icon(Icons.place, size: 16, color: Colors.white),
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: StreamBuilder<Branch>(
                      stream: bloc.locationStream,
                      builder: (context, snapshot) {
                        var locationName = "";
                        if (snapshot.hasData) {
                          locationName = snapshot.data.branchName;
                        }
                        return Text(locationName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ));
                      }),
                ),
              ],
            ),
            Expanded(
              child: StreamBuilder<int>(
                  stream: bloc.pendingUploadCountStream,
                  builder: (context, snapshot) {
                    var count = 0;
                    if (snapshot.hasData) {
                      count = snapshot.data;
                    }
                    return Text("Pending Upload : $count",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ));
                  }),
            ),
            Container(width: 80, height: 0),
          ],
        ),
      ),
    );
  }
}
