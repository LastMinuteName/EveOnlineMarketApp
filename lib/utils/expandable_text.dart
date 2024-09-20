import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        GestureDetector(
          onTap: () { setState(() => expanded = !expanded );},
          child: Text(
            AppLocalizations.of(context)!.expandableTextReadLessButton,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
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
        GestureDetector(
          onTap: () { setState(() => expanded = !expanded );},
          child: Text(
            AppLocalizations.of(context)!.expandableTextReadMoreButton,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}