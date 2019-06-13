import 'package:flutter/material.dart';

class DisplayField extends StatelessWidget {
  final String title, value;

  DisplayField({this.title = "", this.value = ""});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(title, style: TextStyle(fontSize: 10, color: Colors.grey[700])),
        ),
        Container(
          padding: EdgeInsets.only(top: 4, left: 8, bottom: 8),
          decoration: const BoxDecoration(
            border: BorderDirectional(bottom: BorderSide(color: Colors.grey)),
          ),
          child: Text(value, style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }
}
