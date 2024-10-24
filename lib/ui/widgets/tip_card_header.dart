import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../commons/assets.dart';
import '../../commons/constants.dart';
import '../../commons/extensions.dart';
import '../../commons/values.dart';
import '../../commons/utils.dart';
import 'custom_image.dart';

class TipCardHeader extends StatelessWidget {
  const TipCardHeader({
    super.key,
    required this.leagueId,
    required this.leagueName,
    required this.fixtureTimestamp,
  });

  final int leagueId;
  final String leagueName;
  final int fixtureTimestamp;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(DefaultValues.padding / 2),
      width: double.infinity,
      // color: context.colorScheme.secondaryContainer,
      child: Row(
        children: [
          Container(
            height: 20.h,
            width: 20.h,
            clipBehavior: Clip.hardEdge,
            decoration: ShapeDecoration(
              shape: CircleBorder(
                side: BorderSide(
                  color: context.colorScheme.primary,
                  strokeAlign: BorderSide.strokeAlignOutside,
                ),
              ),
            ),
            child: CustomNetworkImage(
              imageUrl: leagueLogo(leagueId),
              placeholder: Assets.leagueLogoPlaceholder,
              fit: BoxFit.scaleDown,
            ),
          ),
          Gap(DefaultValues.padding / 2),
          Expanded(
            child: Text(
              leagueName,
              style: context.textTheme.titleMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Gap(DefaultValues.padding / 2),
          Text(
            DateFormat(Constants.fullDatePattern).format(
              DateTime.fromMillisecondsSinceEpoch(fixtureTimestamp * 1000),
            ),
            style: context.textTheme.titleSmall,
          ),
        ],
      ),
    );
  }
}