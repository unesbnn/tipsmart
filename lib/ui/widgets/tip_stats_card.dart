import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../commons/extensions.dart';
import '../../commons/values.dart';

class TipStatsCard extends StatelessWidget {
  const TipStatsCard({
    super.key,
    required this.title,
    required this.path,
    required this.count,
    this.direction = Axis.vertical, this.elevation, this.backgroundColor,
  });

  final String title;
  final String path;
  final String count;
  final double? elevation;
  final Color? backgroundColor;
  final Axis direction;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      color: backgroundColor,
      child: Padding(
        padding: EdgeInsets.all(DefaultValues.padding / 2),
        child: direction == Axis.vertical
            ? Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _iconWidget(path, 30.h),
                  Gap(DefaultValues.spacing / 2),
                  _countWidget(context, title),
                  Gap(DefaultValues.spacing / 4),
                  _countWidget(context, count),
                ],
              )
            : Row(
                children: [
                  _iconWidget(path, 40.h),
                  Expanded(
                    child: Column(
                      children: [
                        _titleWidget(context, title),
                        Gap(DefaultValues.spacing / 4),
                        _countWidget(context, count),
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }

  Widget _titleWidget(BuildContext context, String title) {
    return Text(
      title.toUpperCase(),
      style: context.textTheme.labelMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }

  Widget _countWidget(BuildContext context, String count) {
    return Text(
      count,
      style: context.textTheme.labelMedium,
      textAlign: TextAlign.center,
      maxLines: 1,
    );
  }

  Widget _iconWidget(String path, double dimension) {
    return Image.asset(
      path,
      height: dimension,
      width: dimension,
    );
  }
}
