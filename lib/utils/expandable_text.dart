import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;
  final TextOverflow overflow;
  final TextStyle? textStyle;

  const ExpandableText({
    super.key,
    required this.text,
    required this.maxLines,
    required this.overflow,
    this.textStyle
  });

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final span = TextSpan(text: widget.text, style: widget.textStyle ?? const TextStyle());
        final tp = TextPainter(text: span, textDirection: TextDirection.ltr);
        tp.layout(maxWidth: constraints.maxWidth);
        final numLines = tp.computeLineMetrics().length;

        if (numLines <= widget.maxLines) {
          return Align(
            alignment: Alignment.topLeft,
            child: Text(widget.text)
          );
        }
        else {
          return AnimatedCrossFade(
            firstCurve: Curves.linear,
            secondCurve: Curves.linear,
            firstChild: _retractedText(),
            secondChild: _expandedText(),
            crossFadeState: !expanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 250),
          );
        }

      }
    );
  }

  Widget _expandedText() {
    return GestureDetector(
      onTap: () { setState(() => expanded = !expanded );},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.text,
            style: widget.textStyle,
          ),
          Container(
            color: Colors.transparent,
            alignment: Alignment.center,
            child: Text(
              AppLocalizations.of(context)!.expandableTextReadLessButton,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _retractedText() {
    return GestureDetector(
      onTap: () { setState(() => expanded = !expanded );},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.text,
            maxLines: widget.maxLines,
            overflow: widget.overflow,
            style: widget.textStyle,
          ),
          Container(
            color: Colors.transparent,
            alignment: Alignment.center,
            child: Text(
              AppLocalizations.of(context)!.expandableTextReadMoreButton,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}