import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../commons/extensions.dart';
import '../../commons/utils.dart';
import '../../commons/values.dart';

class BetValueWidget extends StatelessWidget {
  const BetValueWidget({
    super.key,
    required this.betValueName,
    required this.betValueOdd,
    this.expand = false,
    this.backgroundColor,
    this.direction = Axis.horizontal,
    this.borderColor,
  });

  final String betValueName;
  final double betValueOdd;
  final bool expand;
  final Color? backgroundColor;
  final Color? borderColor;
  final Axis direction;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [
      Text(
        betValueName,
        style: context.textTheme.labelMedium?.copyWith(),
        textAlign: TextAlign.center,
      ),
      SizedBox(
        height: direction == Axis.horizontal ? 24.h : null,
        child: direction == Axis.horizontal
            ? VerticalDivider(
                color: borderColor ?? context.colorScheme.primary,
              )
            : Divider(
                color: borderColor ?? context.colorScheme.primary,
                height: DefaultValues.spacing,
              ),
      ),
      if (!expand)
        _betValueOddText(
          context,
          betValueOdd.toStringAsFixed(2),
        ),
      if (expand)
        Expanded(
          child: _betValueOddText(
            context,
            formatNumber(betValueOdd, excludeK: true),
          ),
        ),
    ];
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
        horizontal: DefaultValues.padding / 2,
        vertical: DefaultValues.padding / 4,
      ),
      decoration: ShapeDecoration(
        color: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DefaultValues.radius / 2),
          side: BorderSide(color: borderColor ?? context.colorScheme.primary),
        ),
      ),
      child: direction == Axis.horizontal
          ? Row(children: children)
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
    );
  }

  Widget _betValueOddText(BuildContext context, String test) {
    return Text(
      formatNumber(betValueOdd, excludeK: true),
      style: context.textTheme.labelMedium,
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
