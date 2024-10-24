import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../commons/app_config.dart';
import '../../commons/assets.dart';
import '../../commons/extensions.dart';
import '../../commons/values.dart';

class AppInfoWidget extends StatelessWidget {
  const AppInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(DefaultValues.radius),
            color: context.colorScheme.secondaryContainer,
          ),
          child: Image.asset(
            Assets.appIcon,
            height: .4.sw,
            width: .4.sw,
          ),
        ),
        Gap(DefaultValues.padding),
        Text(
          AppConfig.name,
          style: context.textTheme.titleLarge,
        ),
        Gap(DefaultValues.padding / 2),
        Text(
          AppConfig.appSlogan,
          style: context.textTheme.titleMedium,
        ),
      ],
    );
  }
}
