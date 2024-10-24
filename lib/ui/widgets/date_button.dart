import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../commons/constants.dart';
import '../../commons/extensions.dart';
import '../../commons/values.dart';

class DateButton extends StatelessWidget {
  const DateButton({
    super.key,
    required this.title,
    required this.date,
    this.onSelected,
    required this.selected,
  });

  final String title;
  final DateTime date;
  final bool selected;
  final Function(bool)? onSelected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      padding: EdgeInsets.symmetric(vertical: DefaultValues.padding / 2),
      selected: selected,
      showCheckmark: false,
      onSelected: onSelected,
      label: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Text(
              title,
              style: context.textTheme.labelMedium?.copyWith(
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
            Gap(DefaultValues.spacing / 4),
            Text(
              DateFormat(Constants.shortDatePattern).format(date),
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}