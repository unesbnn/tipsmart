import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../commons/assets.dart';
import '../../commons/extensions.dart';
import '../../commons/values.dart';
import '../../commons/utils.dart';
import 'custom_image.dart';

class FixtureWidget extends StatelessWidget {
  const FixtureWidget({
    super.key,
    required this.homeTeamId,
    required this.homeTeamName,
    required this.awayTeamId,
    required this.awayTeamName,
    this.score,
  });

  final int homeTeamId;
  final String homeTeamName;
  final int awayTeamId;
  final String awayTeamName;
  final Widget? score;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: DefaultValues.padding / 2,
        vertical: DefaultValues.padding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 40.h,
            width: 40.h,
            clipBehavior: Clip.antiAlias,
            padding: EdgeInsets.all(DefaultValues.padding / 4),
            decoration: ShapeDecoration(
              shape: CircleBorder(
                side: BorderSide(
                  color: context.colorScheme.primary,
                  strokeAlign: BorderSide.strokeAlignOutside,
                ),
              ),
            ),
            child: CustomNetworkImage(
              imageUrl: teamLogo(homeTeamId),
              placeholder: Assets.teamLogoPlaceholder,
              fit: BoxFit.scaleDown,
            ),
          ),
          Gap(DefaultValues.padding / 2),
          Expanded(
            child: Text(
              homeTeamName,
              textAlign: TextAlign.start,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (score != null) ...[
            Gap(DefaultValues.padding),
            score!,
            Gap(DefaultValues.padding),
          ],
          Expanded(
            child: Text(
              awayTeamName,
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Gap(DefaultValues.padding / 2),
          Container(
            height: 40.h,
            width: 40.h,
            clipBehavior: Clip.antiAlias,
            padding: EdgeInsets.all(DefaultValues.padding / 4),
            decoration: ShapeDecoration(
              shape: CircleBorder(
                side: BorderSide(
                  color: context.colorScheme.primary,
                  strokeAlign: BorderSide.strokeAlignOutside,
                ),
              ),
            ),
            child: CustomNetworkImage(
              imageUrl: teamLogo(awayTeamId),
              placeholder: Assets.teamLogoPlaceholder,
              fit: BoxFit.scaleDown,
            ),
          ),
        ],
      ),
    );
  }
}