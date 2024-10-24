import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../commons/assets.dart';
import '../../../commons/extensions.dart';
import '../../../commons/strings.dart';
import '../../../commons/tip_smart_icons.dart';
import '../../../commons/values.dart';
import '../../../features/ads/ads_manager.dart';
import '../../../features/tips/blocs/api_state.dart';
import '../../../features/tips/blocs/tips_stats_cubit/tips_stats_cubit.dart';
import '../../../features/tips/blocs/tips_stats_cubit/tips_stats_state.dart';
import 'info_widget.dart';
import 'loading_widget.dart';
import 'tip_stats_card.dart';

class TipsStatsWidget extends StatelessWidget {
  const TipsStatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TipsStatsCubit, ApiState>(
      builder: (context, state) {
        if (state is LoadingState) {
          return const LoadingWidget();
        }
        if (state is ErrorState) {
          return InfoWidget(
            text: state.message,
            icon: TipSmartIcons.error,
            color: context.colorScheme.error,
            buttonText: Strings.retry,
            onButtonTaped: () => context.read<TipsStatsCubit>().getTipsStats(),
          );
        }
        if (state is TipsStatsLoadedState) {
          return Column(
            children: [
              Card(
                clipBehavior: Clip.antiAlias,
                elevation: 0,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(DefaultValues.padding / 4),
                      color: context.colorScheme.secondaryContainer,
                      child: Text(
                        Strings.yesterdayStats.toUpperCase(),
                        style: context.textTheme.titleMedium?.copyWith(
                          letterSpacing: 2,
                          // fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
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
                                  count: '${state.yesterdayStats.correct}',
                                ),
                              ),
                              Expanded(
                                child: TipStatsCard(
                                  title: TipStatus.lost.status,
                                  path: Assets.lostBetsIcon,
                                  count: '${state.yesterdayStats.incorrect}',
                                ),
                              ),
                              if (state.yesterdayStats.pending > 0)
                                Expanded(
                                  child: TipStatsCard(
                                    title: TipStatus.pending.status,
                                    path: Assets.pendingBetsIcon,
                                    count: '${state.yesterdayStats.pending}',
                                  ),
                                ),
                              Expanded(
                                child: TipStatsCard(
                                  title: TipStatus.canceled.status,
                                  path: Assets.canceledBetsIcon,
                                  count: '${state.yesterdayStats.canceled}',
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
                                  count: '${state.yesterdayStats.total}',
                                  direction: Axis.horizontal,
                                ),
                              ),
                              Expanded(
                                child: TipStatsCard(
                                  title: Strings.winRate,
                                  path: Assets.wonBetsIcon,
                                  count:
                                      state.yesterdayStats.successRate ?? '-',
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
              Card(
                clipBehavior: Clip.antiAlias,
                elevation: 0,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(DefaultValues.padding / 4),
                      color: context.colorScheme.secondaryContainer,
                      child: Text(
                        Strings.todaySoFar.toUpperCase(),
                        style: context.textTheme.titleMedium?.copyWith(
                          letterSpacing: 2,
                          // fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
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
                                  count: '${state.todayStats.correct}',
                                ),
                              ),
                              Expanded(
                                child: TipStatsCard(
                                  title: TipStatus.lost.status,
                                  path: Assets.lostBetsIcon,
                                  count: '${state.todayStats.incorrect}',
                                ),
                              ),
                              Expanded(
                                child: TipStatsCard(
                                  title: TipStatus.pending.status,
                                  path: Assets.pendingBetsIcon,
                                  count: '${state.todayStats.pending}',
                                ),
                              ),
                              if (state.yesterdayStats.canceled > 0)
                                Expanded(
                                  child: TipStatsCard(
                                    title: TipStatus.canceled.status,
                                    path: Assets.canceledBetsIcon,
                                    count: '${state.todayStats.canceled}',
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
                                  count: '${state.todayStats.total}',
                                  direction: Axis.horizontal,
                                ),
                              ),
                              Expanded(
                                child: TipStatsCard(
                                  title: Strings.winRate,
                                  path: Assets.wonBetsIcon,
                                  count: state.todayStats.successRate ?? '-',
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
              Gap(DefaultValues.spacing / 4),
              AdsManager.instance.mrecAd(),
            ],
          );
        }

        return InfoWidget(
          text: Strings.somethingWentWrong,
          icon: TipSmartIcons.error,
          color: context.colorScheme.error,
          buttonText: Strings.retry,
          onButtonTaped: () => context.read<TipsStatsCubit>().getTipsStats(),
        );
      },
    );
  }
}
