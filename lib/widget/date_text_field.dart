import 'package:ep_cf_operation/util/node_util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTextField extends StatefulWidget {
  final String label;
  final TextEditingController dateTec;

  DateTextField(this.label, this.dateTec);

  @override
  _DateTextFieldState createState() => _DateTextFieldState();
}

class _DateTextFieldState extends State<DateTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.dateTec,
      enableInteractiveSelection: false,
      focusNode: AlwaysDisabledFocusNode(),
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        suffixIcon: Icon(Icons.date_range, color: Colors.white),
        labelText: widget.label,
        contentPadding: const EdgeInsets.all(12),
        labelStyle: TextStyle(color: Colors.white),
      ),
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2010),
          lastDate: DateTime(2050),
        );

        if (selectedDate != null) {
          widget.dateTec.text = DateFormat('yyyy-MM-dd').format(selectedDate);
        }
      },
    );
  }
}
