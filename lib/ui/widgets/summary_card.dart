import 'package:flutter/material.dart';

import '../../commons/extensions.dart';
import '../../commons/values.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({super.key, required this.title, required this.info});

  final String title;
  final String info;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.colorScheme.secondaryContainer,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: DefaultValues.padding / 4,
          vertical: DefaultValues.padding / 2,
        ),
        child: Column(
          children: [
            Text(
              title,
              style: context.textTheme.labelMedium,
              textAlign: TextAlign.center,
            ),
            Divider(color: context.colorScheme.primary),
            Text(
              info,
              style: context.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}