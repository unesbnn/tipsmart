import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../commons/values.dart';
import 'bet_value_widget.dart';

class BetWidget extends StatelessWidget {
  const BetWidget({
    super.key,
    required this.betName,
    required this.betValueName,
    required this.betValueOdd,
    this.betStatus,
    this.add,
    this.onBet,
  });

  final String betName;
  final String betValueName;
  final double betValueOdd;
  final Widget? betStatus;
  final Widget? add;
  final Function()? onBet;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(DefaultValues.padding / 2),
      child: Row(
        children: [
          if (betStatus != null) ...[
            betStatus!,
            Gap(DefaultValues.padding / 2),
          ],
          Expanded(
            child: Text(betName),
          ),
          Gap(DefaultValues.padding / 2),
          GestureDetector(
            onTap: onBet,
            child: BetValueWidget(
              betValueName: betValueName,
              betValueOdd: betValueOdd,
            ),
          ),
          if (add != null) ...[
            Gap(DefaultValues.spacing / 4),
            add!,
          ],
        ],
      ),
    );
  }
}
