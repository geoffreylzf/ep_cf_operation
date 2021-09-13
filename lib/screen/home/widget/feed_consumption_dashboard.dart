import 'package:ep_cf_operation/model/table/cf_feed_consumption.dart';
import 'package:ep_cf_operation/module/shares_preferences_module.dart';
import 'package:ep_cf_operation/res/string.dart';
import 'package:ep_cf_operation/screen/feed_consumption/feed_consumption_screen.dart';
import 'package:ep_cf_operation/screen/feed_consumption_history/feed_consumption_history_screen.dart';
import 'package:ep_cf_operation/screen/home/bloc/home_feed_in_bloc.dart';
import 'package:ep_cf_operation/screen/home/bloc/home_feed_consumption_bloc.dart';
import 'package:ep_cf_operation/widget/card_label_small.dart';
import 'package:ep_cf_operation/widget/simple_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedConsumptionDashboard extends StatefulWidget {
  @override
  _FeedConsumptionDashboardState createState() => _FeedConsumptionDashboardState();
}

class _FeedConsumptionDashboardState extends State<FeedConsumptionDashboard> {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<HomeFeedConsumptionBloc>(context);
    bloc.loadCurrentFeedInList();
    return Stack(
      children: [
        Center(
          child: Opacity(
            opacity: 0.1,
            child: Icon(Icons.grain, size: 250),
          ),
        ),
        ListView(
          children: [
            FeedConsumptionCard(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: RaisedButton.icon(
                icon: Icon(Icons.history),
                label: Text(Strings.history),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    FeedConsumptionHistoryScreen.route,
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class FeedConsumptionCard extends StatefulWidget {
  @override
  _FeedConsumptionCardState createState() => _FeedConsumptionCardState();
}

class _FeedConsumptionCardState extends State<FeedConsumptionCard> {
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
                FeedConsumptionScreen.route,
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0, top: 12, right: 12, bottom: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CardLabelSmall("Feed Consumption Today"),
                CurrentFeedConsumptionList(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        "Tap to enter new feed consumption",
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


class CurrentFeedConsumptionList extends StatefulWidget {
  @override
  _CurrentFeedConsumptionListState createState() => _CurrentFeedConsumptionListState();
}

class _CurrentFeedConsumptionListState extends State<CurrentFeedConsumptionList> {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<HomeFeedConsumptionBloc>(context);
    return StreamBuilder<List<CfFeedConsumption>>(
      stream: bloc.curFeedConsumptionListStream,
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
                            TextSpan(text: "House ", style: TextStyle(fontSize: 10)),
                            TextSpan(
                                text: "#${list[index].houseNo.toString()}",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: [
                            TextSpan(
                              text: list[index].getItemTypeCodeName() + " ",
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                                text: list[index].getBag().toStringAsFixed(3),
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            TextSpan(text: " Bag ", style: TextStyle(fontSize: 10)),
                            TextSpan(
                                text: list[index].weight.toStringAsFixed(3),
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            TextSpan(text: " Kg ", style: TextStyle(fontSize: 10)),
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
                      "No feed consumption record today.",
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
