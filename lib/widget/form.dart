import 'package:flutter/material.dart';

class FormItemTitle extends StatelessWidget {
  final String title;

  FormItemTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(this.title, style: TextStyle(fontSize: 12, color: Colors.grey));
  }
}
