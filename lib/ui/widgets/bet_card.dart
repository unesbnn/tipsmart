import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../commons/colors.dart';
import '../../commons/extensions.dart';
import '../../commons/tip_smart_icons.dart';
import '../../features/tips/models/tip_model.dart';
import 'bet_widget.dart';
import 'fixture_widget.dart';
import 'tip_card_header.dart';

class BetCard extends StatelessWidget {
  const BetCard({
    super.key,
    required this.bet,
  });

  final Tip bet;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          TipCardHeader(
            leagueId: bet.leagueId,
            leagueName: bet.leagueName,
            fixtureTimestamp: bet.fixtureTimestamp,
          ),
          Divider(color: context.colorScheme.secondaryContainer, height: 0),
          FixtureWidget(
            homeTeamId: bet.homeTeamId,
            homeTeamName: bet.homeTeamName,
            awayTeamId: bet.awayTeamId,
            awayTeamName: bet.awayTeamName,
            score: _scoreWidget(context),
          ),
          Divider(
            color: context.colorScheme.secondaryContainer,
            height: 0,
          ),
          BetWidget(
            betName: bet.betName,
            betValueName: bet.betValueName,
            betValueOdd: bet.betValueOdd,
            betStatus: _betStatusIcon(
                bet.status.toTipStatus, context.colorScheme.error),
          ),
        ],
      ),
    );
  }

  Widget _scoreWidget(BuildContext context) {
    if (bet.status == TipStatus.pending.status) {
      return Icon(
        TipSmartIcons.clock,
        color: AppColors.orangeColor,
        size: 20.r,
      );
    }
    if (bet.status == TipStatus.canceled.status) {
      return Text(bet.fixtureStatus);
    }
    final List<Widget> scores = [];
    if (bet.fullTimeScore?.isNotEmpty ?? false) {
      scores.add(
        Text(
          bet.fullTimeScore!,
          style: context.textTheme.bodyLarge,
        ),
      );
    }
    if (bet.penaltyScore?.isNotEmpty ?? false) {
      scores.add(
        Text(
          '(${bet.penaltyScore})',
          style: context.textTheme.labelMedium,
        ),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: scores,
    );
  }

  Widget? _betStatusIcon(TipStatus status, Color errorColor) {
    switch (status) {
      case TipStatus.pending:
        return Icon(
          TipSmartIcons.clock,
          color: AppColors.transparentColor,
          size: 16.r,
        );
      case TipStatus.won:
        return Icon(
          TipSmartIcons.correct,
          color: AppColors.greenColor,
          size: 16.r,
        );
      case TipStatus.lost:
        return Icon(
          TipSmartIcons.incorrect,
          color: errorColor,
          size: 16.r,
        );
      case TipStatus.canceled:
      default:
        return null;
    }
  }
}
