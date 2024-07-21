import 'package:flutter/material.dart';

const padding8 = EdgeInsets.all(8);
const padding10 = EdgeInsets.only(left: 10);
const textStyleBoldWhite = TextStyle(color: Colors.white);

//Section Header
class SectionHeader extends StatelessWidget {
  final String text;
  final EdgeInsets padding;

  SectionHeader({required this.text, required this.padding});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: padding,
        child: Text(
          text,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

// Value Container
class ValueContainer extends StatelessWidget {
  final String label;
  final double value;

  ValueContainer({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 11),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            value.toStringAsFixed(2),
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// Legend Item
class LegendItem extends StatelessWidget {
  final String label;
  final Color color;
  final TextStyle? textStyle;

  LegendItem({required this.label, required this.color, this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: textStyle ?? TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
