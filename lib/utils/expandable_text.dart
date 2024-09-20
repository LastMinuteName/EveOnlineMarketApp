import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;
  final TextOverflow overflow;
  final EdgeInsets? padding;

  const ExpandableText({
    super.key,
    required this.text,
    required this.maxLines,
    required this.overflow,
    this.padding
  });

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding ?? widget.padding,
      child: expanded ? _expandedText() : _retractedText()
    );
  }

  Widget _expandedText() {
    return Column(
      children: [
        Text(widget.text),
        TextButton(
          onPressed: () { setState(() => expanded = !expanded );},
          child: Text("Read Less"),
        ),
      ],
    );
  }

  Widget _retractedText() {
    return Column(
      children: [
        Text(
          widget.text,
          maxLines: widget.maxLines,
          overflow: widget.overflow,
        ),
        TextButton(
          onPressed: () { setState(() => expanded = !expanded );},
          child: Text("Read More"),
        ),
      ],
    );
  }
}