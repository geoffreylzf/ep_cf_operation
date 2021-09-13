import 'package:ep_cf_operation/model/table/cf_feed_in.dart';
import 'package:ep_cf_operation/module/shares_preferences_module.dart';
import 'package:ep_cf_operation/res/string.dart';
import 'package:ep_cf_operation/screen/feed_in/feed_in_screen.dart';
import 'package:ep_cf_operation/screen/feed_in_history/feed_in_history_screen.dart';
import 'package:ep_cf_operation/screen/home/bloc/home_feed_in_bloc.dart';
import 'package:ep_cf_operation/widget/card_label_small.dart';
import 'package:ep_cf_operation/widget/simple_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedDashboard extends StatefulWidget {
  @override
  _FeedDashboardState createState() => _FeedDashboardState();
}

class _FeedDashboardState extends State<FeedDashboard> {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<HomeFeedInBloc>(context);
    bloc.loadCurrentFeedInList();
    return Stack(
      children: [
        Center(
          child: Opacity(
            opacity: 0.1,
            child: Icon(Icons.local_shipping_outlined, size: 250),
          ),
        ),
        ListView(
          children: [
            FeedInCard(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: RaisedButton.icon(
                icon: Icon(Icons.history),
                label: Text(Strings.history),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    FeedInHistoryScreen.route,
                  );
                },
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
            //   child: Row(
            //     children: [
            //       Expanded(
            //         child: RaisedButton.icon(
            //           icon: Icon(FontAwesomeIcons.signOutAlt, size: 16),
            //           label: Text(Strings.feedDischarge),
            //           onPressed: () {
            //             Navigator.pushNamed(context, FeedDischargeScreen.route);
            //           },
            //         ),
            //       ),
            //       Container(width: 8),
            //       Expanded(
            //         child: RaisedButton.icon(
            //           icon: Icon(FontAwesomeIcons.signInAlt, size: 16),
            //           label: Text(Strings.feedReceive),
            //           onPressed: () {},
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ],
    );
  }
}

class FeedInCard extends StatefulWidget {
  @override
  _FeedInCardState createState() => _FeedInCardState();
}

class _FeedInCardState extends State<FeedInCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 24,
        child: InkWell(
          onTap: () async {
            final companyId = await SharedPreferencesModule().getCompanyId();
            final locationId = await SharedPreferencesModule().getLocationId();

            if (companyId == null || locationId == null) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SimpleAlertDialog(
                      title: Strings.error,
                      message: "Either company or location is not set",
                    );
                  });
            } else {
              await new Future.delayed(const Duration(milliseconds: 300));
              Navigator.pushNamed(
                context,
                FeedInScreen.route,
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0, top: 12, right: 12, bottom: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CardLabelSmall("Feed In Today"),
                CurrentFeedInList(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        "Tap to enter new feed in",
                        style: TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CurrentFeedInList extends StatefulWidget {
  @override
  _CurrentFeedInListState createState() => _CurrentFeedInListState();
}

class _CurrentFeedInListState extends State<CurrentFeedInList> {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<HomeFeedInBloc>(context);
    return StreamBuilder<List<CfFeedIn>>(
      stream: bloc.curFeedInListStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final list = snapshot.data;
        if (list.length > 0) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: list.length,
            itemBuilder: (ctx, index) {
              var rowColor = Theme.of(context).highlightColor;
              if (index % 2 == 0) {
                rowColor = Colors.green[100];
              }
              return Container(
                color: rowColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: [
                            TextSpan(text: "Doc No ", style: TextStyle(fontSize: 10)),
                            TextSpan(
                                text: "${list[index].docNo.toString()}",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: [
                            TextSpan(text: " Truck No ", style: TextStyle(fontSize: 10)),
                            TextSpan(
                                text: list[index].truckNo.toString(),
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          return SizedBox(
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(Icons.info_outline, color: Colors.white, size: 16),
                    ),
                    Container(width: 4),
                    Text(
                      "No feed in record today.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
