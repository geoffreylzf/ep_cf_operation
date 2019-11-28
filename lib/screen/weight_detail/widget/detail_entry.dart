import 'package:ep_cf_operation/model/enum.dart';
import 'package:ep_cf_operation/res/string.dart';
import 'package:ep_cf_operation/screen/weight_detail/weight_detail_bloc.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class DetailEntry extends StatefulWidget {
  @override
  _DetailEntryState createState() => _DetailEntryState();
}

class _DetailEntryState extends State<DetailEntry> {
  final _formKey = GlobalKey<FormState>();
  final sectionTec = TextEditingController();
  final qtyTec = TextEditingController();
  final weightTec = TextEditingController();
  final weightFn = FocusNode();

  @override
  void initState() {
    super.initState();
    sectionTec.text = "1";
  }

  @override
  void dispose() {
    sectionTec.dispose();
    weightTec.dispose();
    qtyTec.dispose();
    weightFn.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<WeightDetailBloc>(context);
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: sectionTec,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: Strings.section,
                contentPadding: const EdgeInsets.all(8),
                prefixIcon: Icon(Icons.change_history)),
            validator: (value) {
              if (value.isEmpty) {
                return Strings.msgCannotBlank;
              }
              if (int.tryParse(value) == null) {
                return Strings.msgNumberOnly;
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              Strings.gender,
              style: TextStyle(fontSize: 12),
            ),
          ),
          StreamBuilder<Gender>(
              stream: bloc.genderStream,
              builder: (context, snapshot) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Radio(
                          value: Gender.M,
                          groupValue: snapshot.data,
                          onChanged: (value) {
                            bloc.setGender(value);
                          },
                        ),
                        Text(Strings.male),
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          value: Gender.F,
                          groupValue: snapshot.data,
                          onChanged: (value) {
                            bloc.setGender(value);
                          },
                        ),
                        Text(Strings.female),
                      ],
                    )
                  ],
                );
              }),
          TextFormField(
            controller: qtyTec,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: Strings.quantity,
                contentPadding: const EdgeInsets.all(8),
                prefixIcon: Icon(FontAwesomeIcons.dove)),
            validator: (value) {
              if (value.isEmpty) {
                return Strings.msgCannotBlank;
              }
              if (int.tryParse(value) == null) {
                return Strings.msgNumberOnly;
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TextFormField(
              controller: weightTec,
              focusNode: weightFn,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: Strings.weightGram,
                  contentPadding: const EdgeInsets.all(8),
                  prefixIcon: Icon(FontAwesomeIcons.weight)),
              validator: (value) {
                if (value.isEmpty) {
                  return Strings.msgCannotBlank;
                }
                if (int.tryParse(value) == null) {
                  return Strings.msgNumberOnly;
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: SizedBox(
              width: double.infinity,
              child: RaisedButton.icon(
                icon: Icon(Icons.arrow_back),
                label: Text(Strings.save.toUpperCase()),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    final section = int.tryParse(sectionTec.text);
                    final qty = int.tryParse(qtyTec.text);
                    final weight = int.tryParse(weightTec.text);

                    final res = await bloc.insertDetail(section, qty, weight);
                    if (res) {
                      weightTec.text = "";
                      FocusScope.of(context).requestFocus(weightFn);
                    }
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
