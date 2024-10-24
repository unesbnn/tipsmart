import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../commons/assets.dart';
import '../../commons/extensions.dart';
import '../../commons/strings.dart';
import '../../commons/values.dart';
import '../../features/tips/repositories/fake_bets_repository.dart';
import 'balance_card.dart';
import 'tip_stats_card.dart';

class BettingStatsWidget extends StatelessWidget {
  const BettingStatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: context.read<FakeBetsRepository>().statsBox.listenable(),
      builder: (context, box, widget) {
        final bettingStats = context.read<FakeBetsRepository>().getBettingStats();
        final totalEnded = bettingStats.wonBets + bettingStats.lostBets;
        final String successRate = (totalEnded > 0)
            ? '${(100 * bettingStats.wonBets / totalEnded).toStringAsFixed(2)}%'
            : '-';
        return Column(
          children: [
            BalanceCard(bettingStats: bettingStats),
            Gap(DefaultValues.spacing / 4),
            Card(
              elevation: 0,
              clipBehavior: Clip.antiAlias,
              // color: context.colorScheme.secondaryContainer,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(DefaultValues.padding / 2),
                    // color: context.colorScheme.secondaryContainer,
                    child: Text(
                      Strings.yourBettingStats.toUpperCase(),
                      style: context.textTheme.titleMedium?.copyWith(
                        letterSpacing: 2,
                        // fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Divider(height: 0),
                  Container(
                    padding: EdgeInsets.all(DefaultValues.padding / 4),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TipStatsCard(
                                title: TipStatus.won.status,
                                path: Assets.wonBetsIcon,
                                count: '${bettingStats.wonBets}',
                              ),
                            ),
                            Expanded(
                              child: TipStatsCard(
                                title: TipStatus.lost.status,
                                path: Assets.lostBetsIcon,
                                count: '${bettingStats.lostBets}',
                              ),
                            ),
                            Expanded(
                              child: TipStatsCard(
                                title: TipStatus.pending.status,
                                path: Assets.pendingBetsIcon,
                                count: '${bettingStats.pendingBets}',
                              ),
                            ),
                            Expanded(
                              child: TipStatsCard(
                                title: TipStatus.canceled.status,
                                path: Assets.canceledBetsIcon,
                                count: '${bettingStats.returnedBets}',
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TipStatsCard(
                                title: Strings.total,
                                path: Assets.totalBetsIcon,
                                count: '${bettingStats.totalBets}',
                                direction: Axis.horizontal,
                              ),
                            ),
                            Expanded(
                              child: TipStatsCard(
                                title: Strings.winRate,
                                path: Assets.wonBetsIcon,
                                count: successRate,
                                direction: Axis.horizontal,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}


