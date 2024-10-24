import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../commons/colors.dart';
import '../../commons/constants.dart';
import '../../commons/extensions.dart';
import '../../commons/strings.dart';
import '../../commons/utils.dart';
import '../../commons/values.dart';
import '../../features/tips/models/fake_bet.dart';
import 'bet_card.dart';
import 'dashed_line_painter.dart';

class FakeBetWidget extends StatelessWidget {
  const FakeBetWidget({super.key, required this.fakeBet});

  final FakeBet fakeBet;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          useSafeArea: true,
          isScrollControlled: true,
          clipBehavior: Clip.antiAlias,
          backgroundColor: context.colorScheme.surface,
          showDragHandle: true,
          // constraints: BoxConstraints(
          //   maxHeight: .7.sh,
          // ),
          builder: (context) {
            return ListView.separated(
              padding: EdgeInsets.all(DefaultValues.padding / 4),
              itemCount: fakeBet.bets.length,
              separatorBuilder: (_, __) => Container(
                margin: EdgeInsets.symmetric(horizontal: DefaultValues.radius / 2),
                child: CustomPaint(
                  painter: DashedLinePainter(color: context.colorScheme.secondary),
                ),
              ),
              itemBuilder: (context, index) {
                return BetCard(bet: fakeBet.bets[index]);
              },
            );
          },
        );
      },
      child: Card(
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: EdgeInsets.all(DefaultValues.padding / 2),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 80.w,
                    child: Text(
                      fakeBet.bets.length == 1 ? Strings.single : '${Strings.multi} (${fakeBet.bets.length})',
                    ),
                  ),
                  Gap(DefaultValues.spacing),
                  Expanded(
                    child: Text(
                      DateFormat(Constants.fullDatePattern).format(fakeBet.date),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Gap(DefaultValues.spacing),
                  Container(
                    width: 80.w,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(
                      vertical: DefaultValues.padding / 4,
                      horizontal: DefaultValues.padding,
                    ),
                    decoration: ShapeDecoration(
                      shape: const StadiumBorder(),
                      color: fakeBet.status.toTipStatus.color,
                    ),
                    child: FittedBox(
                      child: Text(
                        fakeBet.status,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Gap(DefaultValues.spacing / 2),
              Container(
                height: 32.h,
                padding: EdgeInsets.symmetric(
                  vertical: DefaultValues.padding / 4,
                  horizontal: DefaultValues.padding / 2,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(DefaultValues.radius / 4),
                  color: context.colorScheme.secondaryContainer,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(Strings.stake),
                          Gap(DefaultValues.spacing / 2),
                          // Text(fakeBet.stake.toStringAsFixed(2)),
                          Text(formatNumber(fakeBet.stake)),
                        ],
                      ),
                    ),
                    VerticalDivider(color: context.colorScheme.primary),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(Strings.odds),
                          Gap(DefaultValues.spacing / 2),
                          Text(formatNumber(fakeBet.odds)),
                        ],
                      ),
                    ),
                    VerticalDivider(color: context.colorScheme.primary),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_returnText()),
                          Gap(DefaultValues.spacing / 2),
                          Text(_returnAmountText()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _returnText() {
    if (fakeBet.status == TipStatus.won.status) {
      return Strings.won;
    }
    if (fakeBet.status == TipStatus.lost.status) {
      return Strings.lost;
    }
    if (fakeBet.status == TipStatus.canceled.status) {
      return Strings.returned;
    }
    return Strings.toWin;
  }

  String _returnAmountText() {
    final String s = formatNumber(fakeBet.returnAmount, excludeU: true);
    if (fakeBet.status == TipStatus.won.status) {
      return '+$s';
    }
    return s;
  }
}
