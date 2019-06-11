import 'package:flutter/material.dart';

class FilterListChip extends StatefulWidget {
  final String text;

  FilterListChip(this.text);

  @override
  _FilterListChipState createState() => _FilterListChipState();
}

class _FilterListChipState extends State<FilterListChip> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Chip(
        backgroundColor: Theme.of(context).primaryColorDark,
        label: Text(widget.text,
            style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold)),
        padding: EdgeInsets.all(4),
      ),
    );
  }
}