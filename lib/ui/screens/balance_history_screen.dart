import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../../commons/colors.dart';
import '../../commons/constants.dart';
import '../../commons/extensions.dart';
import '../../commons/strings.dart';
import '../../commons/utils.dart';
import '../../commons/values.dart';
import '../../features/ads/ads_manager.dart';
import '../../features/tips/models/balance_history.dart';
import '../../features/tips/repositories/fake_bets_repository.dart';
import '../widgets/balance_card.dart';

class BalanceHistoryScreen extends StatelessWidget {
  const BalanceHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(Strings.balanceHistory)),
      bottomNavigationBar: AdsManager.instance.bannerAd(),
      body: SafeArea(
        child: Column(
          children: [
            ValueListenableBuilder(
                valueListenable: context.read<FakeBetsRepository>().statsBox.listenable(),
                builder: (context, box, widget) {
                  final bettingStats = context.read<FakeBetsRepository>().getBettingStats();
                  return BalanceCard(bettingStats: bettingStats, topLevel: false);
                }),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: context.read<FakeBetsRepository>().balanceHistoryBox.listenable(),
                builder: (context, box, widget) {
                  final List<BalanceHistory> history =
                      context.read<FakeBetsRepository>().getAllBalanceHistory();
                  return ListView.builder(
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      final double amount = history[index].amount;
                      return ListTile(
                        title: Text(history[index].description),
                        subtitle:
                            Text(DateFormat(Constants.fullDatePattern).format(history[index].date)),
                        leading: Transform.rotate(
                          angle: 45,
                          child: Icon(
                            amount > 0 ? Icons.arrow_upward : Icons.arrow_downward,
                            color: amount > 0 ? AppColors.greenColor : AppColors.redColor,
                          ),
                        ),
                        trailing: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: DefaultValues.padding / 2,
                            horizontal: DefaultValues.padding,
                          ),
                          decoration: ShapeDecoration(
                            shape: const StadiumBorder(),
                            color: history[index].type.color,
                          ),
                          child: Text(
                            (amount > 0 ? '+' : '') + formatNumber(amount, excludeK: true),
                            style: context.textTheme.bodySmall?.copyWith(
                              color: AppColors.whiteColor,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
