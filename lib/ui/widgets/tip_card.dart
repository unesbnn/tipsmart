import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../commons/colors.dart';
import '../../commons/extensions.dart';
import '../../commons/strings.dart';
import '../../commons/tip_smart_icons.dart';
import '../../commons/values.dart';
import '../../features/tips/models/tip_model.dart';
import '../../features/tips/repositories/betslip_repository.dart';
import 'bet_widget.dart';
import 'fixture_widget.dart';
import 'tip_card_header.dart';

class TipCard extends StatelessWidget {
  const TipCard({
    super.key,
    required this.tip,
    this.margin,
    this.elevation,
    this.hideAddButton = false,
    this.onBet,
  });

  final Tip tip;
  final EdgeInsets? margin;
  final double? elevation;
  final bool hideAddButton;
  final Function()? onBet;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: margin,
      elevation: elevation,
      child: Column(
        children: [
          TipCardHeader(
            leagueId: tip.leagueId,
            leagueName: tip.leagueName,
            fixtureTimestamp: tip.fixtureTimestamp,
          ),
          Divider(color: context.colorScheme.secondaryContainer, height: 0),
          FixtureWidget(
            homeTeamId: tip.homeTeamId,
            homeTeamName: tip.homeTeamName,
            awayTeamId: tip.awayTeamId,
            awayTeamName: tip.awayTeamName,
            score: _scoreWidget(context),
          ),
          Divider(
            color: context.colorScheme.secondaryContainer,
            height: 0,
          ),
          BetWidget(
            betName: tip.betName,
            betValueName: tip.betValueName,
            betValueOdd: tip.betValueOdd,
            betStatus: _betStatusIcon(
                tip.status.toTipStatus, context.colorScheme.error),
            onBet: onBet,
            add: hideAddButton
                ? null
                : ValueListenableBuilder<Box<Tip>>(
                    valueListenable:
                        context.read<BetSlipRepository>().box.listenable(),
                    builder: (context, box, widget) {
                      bool isInSimulator = context
                          .read<BetSlipRepository>()
                          .simulatorContainsBet(tip.id);

                      return IconButton.filled(
                        onPressed: () {
                          if (!tip.canAddToSimulator() && !isInSimulator) {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content: const Text(Strings.cantAddToBetSlip),
                                  backgroundColor: context.colorScheme.error,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                          } else {
                            isInSimulator =
                                context.read<BetSlipRepository>().switchS(tip);

                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content: Text(
                                    isInSimulator
                                        ? Strings.betAdded
                                        : Strings.betDeleted,
                                  ),
                                  backgroundColor: isInSimulator
                                      ? AppColors.greenColor
                                      : context.colorScheme.error,
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                          }
                        },
                        isSelected: isInSimulator,
                        style: IconButton.styleFrom(
                          side: BorderSide(color: context.colorScheme.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(DefaultValues.radius / 2),
                          ),
                        ),
                        icon: Icon(isInSimulator ? Icons.remove : Icons.add),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _scoreWidget(BuildContext context) {
    if (tip.status == TipStatus.pending.status) {
      return Icon(
        TipSmartIcons.clock,
        color: AppColors.orangeColor,
        size: 20.r,
      );
    }
    if (tip.status == TipStatus.canceled.status) {
      return Text(tip.fixtureStatus);
    }
    final List<Widget> scores = [];
    if (tip.fullTimeScore?.isNotEmpty ?? false) {
      scores.add(
        Text(
          tip.fullTimeScore!,
          style: context.textTheme.bodyLarge,
        ),
      );
    }
    if (tip.penaltyScore?.isNotEmpty ?? false) {
      scores.add(
        Text(
          '(${tip.penaltyScore})',
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
