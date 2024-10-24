import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

import '../../commons/extensions.dart';
import '../../commons/strings.dart';

class ChangeThemeDialog extends StatefulWidget {
  const ChangeThemeDialog({
    super.key,
  });

  @override
  State<ChangeThemeDialog> createState() => _ChangeThemeDialogState();
}

class _ChangeThemeDialogState extends State<ChangeThemeDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titleTextStyle: context.textTheme.titleLarge,
      title: const Text(Strings.changeTheme),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RadioListTile(
            title: const Text(Strings.light),
            value: AdaptiveThemeMode.light,
            groupValue: AdaptiveTheme.of(context).mode,
            activeColor: context.colorScheme.primary,
            onChanged: (value) {
              setState(() => AdaptiveTheme.of(context).setLight());
              Navigator.of(context).pop();
            },
          ),
          RadioListTile(
            title: const Text(Strings.dark),
            value: AdaptiveThemeMode.dark,
            groupValue: AdaptiveTheme.of(context).mode,
            activeColor: context.colorScheme.primary,
            onChanged: (value) {
              setState(() => AdaptiveTheme.of(context).setDark());
              Navigator.of(context).pop();
            },
          ),
          RadioListTile(
            title: const Text(Strings.system),
            value: AdaptiveThemeMode.system,
            groupValue: AdaptiveTheme.of(context).mode,
            activeColor: context.colorScheme.primary,
            onChanged: (value) {
              setState(() => AdaptiveTheme.of(context).setSystem());
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
