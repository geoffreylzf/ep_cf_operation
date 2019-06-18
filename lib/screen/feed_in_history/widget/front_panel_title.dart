import 'package:ep_cf_operation/screen/feed_in_history/feed_in_history_bloc.dart';
import 'package:ep_cf_operation/widget/filter_chip.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FrontPanelTitle extends StatefulWidget {
  @override
  _FrontPanelTitleState createState() => _FrontPanelTitleState();
}

class _FrontPanelTitleState extends State<FrontPanelTitle> {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<FeedInHistoryBloc>(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: StreamBuilder<List<String>>(
          stream: bloc.filterListStream,
          builder: (context, snapshot) {
            var arr = [];
            if (snapshot.hasData) {
              snapshot.data.forEach((text) {
                arr.add(FilterListChip(text));
              });
            }

            if (arr.length == 0) {
              arr.add(FilterListChip("All"));
            }

            return ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: [
                ...arr,
              ],
            );
          }),
    );
  }
}
