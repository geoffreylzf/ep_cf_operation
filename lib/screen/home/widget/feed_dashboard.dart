import 'package:ep_cf_operation/screen/feed_in/feed_in_screen.dart';
import 'package:flutter/material.dart';

class FeedDashboard extends StatefulWidget {
  @override
  _FeedDashboardState createState() => _FeedDashboardState();
}

class _FeedDashboardState extends State<FeedDashboard> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        child: Text("Feed In"),
        onPressed: () async{
          await new Future.delayed(const Duration(milliseconds: 300));
          Navigator.pushNamed(
            context,
            FeedInScreen.route,
          );
        },
      ),
    );
  }
}
