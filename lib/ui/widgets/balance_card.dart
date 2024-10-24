import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../commons/assets.dart';
import '../../commons/constants.dart';
import '../../commons/extensions.dart';
import '../../commons/strings.dart';
import '../../commons/utils.dart';
import '../../commons/values.dart';
import '../../features/ads/ads_manager.dart';
import '../../features/tips/models/balance_history.dart';
import '../../features/tips/models/betting_statistics.dart';
import '../../features/tips/repositories/fake_bets_repository.dart';
import '../screens/balance_history_screen.dart';

class BalanceCard extends StatefulWidget {
  const BalanceCard({super.key, required this.bettingStats, this.topLevel = true});

  final BettingStatistics bettingStats;
  final bool topLevel;

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  final _rewardTimestampBox = Hive.box<int>(Constants.lastWatchTimestamp);
  Timer? _timer;
  late int _secondsLeft;

  void _startTimer() {
    _secondsLeft = getLastRewardTimestamp() - _timestampNow() + 10 * 60;
    if (_secondsLeft <= 0) return;
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(() => _secondsLeft--);
        if (_secondsLeft <= 0) {
          timer.cancel();
          _timer?.cancel();
        }
      },
    );
  }

  int getLastRewardTimestamp() {
    return _rewardTimestampBox.get('timestamp', defaultValue: 0)!;
  }

  Future saveLastRewardTimestamp() async {
    final int timestamp = _timestampNow();
    await _rewardTimestampBox.put('timestamp', timestamp);
    _startTimer();
  }

  int _timestampNow() => DateTime.now().millisecondsSinceEpoch ~/ 1000;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: !widget.topLevel ? null : () => context.goTo(const BalanceHistoryScreen()),
      child: Card(
        elevation: 0,
        color: context.colorScheme.secondary,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            vertical: DefaultValues.padding,
            horizontal: DefaultValues.padding,
          ),
          child: Row(
            children: [
              Image.asset(
                Assets.balanceIcon,
                width: 40.h,
                height: 40.h,
              ),
              Gap(DefaultValues.spacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Strings.balance.toUpperCase(),
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.colorScheme.onSecondary,
                      ),
                    ),
                    Text(
                      formatNumber(widget.bettingStats.balance, excludeAll: true),
                      style: context.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.colorScheme.onSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Gap(DefaultValues.spacing),
              ElevatedButton(
                onPressed: _secondsLeft > 0
                    ? () {}
                    : () => AdsManager.instance.showRewardedVideoAd(() {
                          _rewardUser(context);
                          _showCongratsDialog(context);
                          saveLastRewardTimestamp();
                        }),
                style: ElevatedButton.styleFrom(
                  disabledForegroundColor: context.colorScheme.surface,
                  disabledBackgroundColor: context.colorScheme.onSurface,
                  padding: EdgeInsets.symmetric(
                    vertical: DefaultValues.padding / 4,
                    horizontal: DefaultValues.padding,
                  ),
                ),
                child: SizedBox(
                  width: 80,
                  child: Column(
                    children: [
                      Image.asset(
                        Assets.videoAdIcon,
                        width: 26.h,
                        height: 26.h,
                      ),
                      Gap(DefaultValues.spacing / 4),
                      Text(
                        _secondsLeft <= 0
                            ? '+${Constants.videoAdReward} ${Strings.coins}'
                            : _timeLeft(),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _timeLeft() {
    final minutes = '${_secondsLeft ~/ 60}'.padLeft(2, '0');
    final seconds = '${_secondsLeft % 60}'.padLeft(2, '0');

    return '$minutes:$seconds';
  }

  void _rewardUser(BuildContext context) {
    context.read<FakeBetsRepository>().saveBettingStats(
          widget.bettingStats
              .copyWith(balance: widget.bettingStats.balance + Constants.videoAdReward),
        );
    context.read<FakeBetsRepository>().saveBalanceHistory(
          amount: Constants.videoAdReward.toDouble(),
          type: BalanceHistoryType.topUp,
        );
  }

  void _showCongratsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          titleTextStyle: context.textTheme.titleLarge,
          actionsAlignment: MainAxisAlignment.center,
          title: const Text(
            Strings.congrats,
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                Strings.toppedUp,
                textAlign: TextAlign.center,
              ),
              Gap(DefaultValues.spacing),
              Text(
                '+${formatNumber(Constants.videoAdReward, excludeAll: true)}',
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(Strings.ok),
            ),
          ],
        );
      },
    );
  }
}
