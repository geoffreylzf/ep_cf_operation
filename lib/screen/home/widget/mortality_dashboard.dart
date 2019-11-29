import 'package:ep_cf_operation/model/table/cf_mortality.dart';
import 'package:ep_cf_operation/module/shares_preferences_module.dart';
import 'package:ep_cf_operation/res/string.dart';
import 'package:ep_cf_operation/screen/home/bloc/home_mortality_bloc.dart';
import 'package:ep_cf_operation/screen/mortality/mortality_screen.dart';
import 'package:ep_cf_operation/screen/mortality_history/mortality_history_screen.dart';
import 'package:ep_cf_operation/widget/card_label_small.dart';
import 'package:ep_cf_operation/widget/simple_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class MortalityDashboard extends StatefulWidget {
  @override
  _MortalityDashboardState createState() => _MortalityDashboardState();
}

class _MortalityDashboardState extends State<MortalityDashboard> {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<HomeMortalityBloc>(context);
    bloc.loadCurrentMortalityList();
    return Stack(
      children: [
        Center(
          child: Opacity(
            opacity: 0.1,
            child: Icon(FontAwesomeIcons.dizzy, size: 250),
          ),
        ),
        ListView(
          children: [
            MortalityCard(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: RaisedButton.icon(
                icon: Icon(Icons.history),
                label: Text(Strings.history),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    MortalityHistoryScreen.route,
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

class MortalityCard extends StatefulWidget {
  @override
  _MortalityCardState createState() => _MortalityCardState();
}

class _MortalityCardState extends State<MortalityCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 24,
        child: InkWell(
          onTap: () async {
            var companyId = await SharedPreferencesModule().getCompanyId();
            var locationId = await SharedPreferencesModule().getLocationId();

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
                MortalityScreen.route,
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0, top: 12, right: 12, bottom: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CardLabelSmall("Mortality Today"),
                CurrentMortalityList(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        "Tap to enter new mortality",
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

class CurrentMortalityList extends StatefulWidget {
  @override
  _CurrentMortalityListState createState() => _CurrentMortalityListState();
}

class _CurrentMortalityListState extends State<CurrentMortalityList> {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<HomeMortalityBloc>(context);
    return StreamBuilder<List<CfMortality>>(
        stream: bloc.curMortalityListStream,
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
                    rowColor = Theme.of(context).primaryColorLight;
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
                                    text: list[index].mQty.toString(),
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                TextSpan(text: " Dead ", style: TextStyle(fontSize: 10)),
                                TextSpan(
                                    text: list[index].rQty.toString(),
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                TextSpan(text: " Reject ", style: TextStyle(fontSize: 10)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
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
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(Icons.info_outline, color: Colors.white, size: 16),
                      ),
                      Container(width: 4),
                      Text(
                        "No mortality record today.",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }
}
