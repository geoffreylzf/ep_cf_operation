import 'package:ep_cf_operation/model/table/temp_cf_weight_detail.dart';
import 'package:ep_cf_operation/res/string.dart';
import 'package:ep_cf_operation/screen/weight_detail/weight_detail_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TempList extends StatefulWidget {
  @override
  _TempListState createState() => _TempListState();
}

class _TempListState extends State<TempList> {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<WeightDetailBloc>(context);
    return Column(
      children: [
        Container(
          color: Theme.of(context).primaryColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(flex: 2, child: ListHeader("#")),
                Expanded(flex: 1, child: ListHeader("G#")),
                Expanded(flex: 4, child: ListHeader(Strings.weight))
              ],
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<List<TempCfWeightDetail>>(
              stream: bloc.tempListStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                var list = snapshot.data;
                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (ctx, position) {
                    var no = list.length - position;
                    var temp = list[position];
                    var bgColor = Theme.of(ctx).scaffoldBackgroundColor;

                    if (no % 2 == 0) {
                      bgColor = Theme.of(ctx).highlightColor;
                    }

                    return Container(
                      color: bgColor,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                no.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: Text(
                                  temp.gender.toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12),
                                )),
                            Expanded(
                                flex: 4,
                                child: Text(
                                  temp.weight.toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12),
                                )),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
        ),
      ],
    );
  }
}

class ListHeader extends StatelessWidget {
  final String text;

  ListHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    );
  }
}
