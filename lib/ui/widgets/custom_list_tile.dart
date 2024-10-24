import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../commons/extensions.dart';
import '../../commons/tip_smart_icons.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    super.key,
    required this.title,
    required this.leading,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final IconData leading;
  final IconData? trailing;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      subtitleTextStyle: context.textTheme.bodySmall,
      titleTextStyle: context.textTheme.bodyLarge,
      leading: Icon(leading),
      trailing: Icon(
        trailing ?? TipSmartIcons.arrowRight,
        size: 16.r,
      ),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
    );
  }
}
