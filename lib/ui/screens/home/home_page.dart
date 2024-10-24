import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../commons/utils.dart';
import '../../../commons/values.dart';
import '../../../features/ads/ads_manager.dart';
import '../../widgets/betting_stats_widget.dart';
import '../../widgets/tips_stats_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showRateDialog(context);
    });
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(DefaultValues.padding / 4),
      child: Column(
        children: [
          const BettingStatsWidget(),
          Gap(DefaultValues.spacing / 4),
          AdsManager.instance.bannerAd(),
          Gap(DefaultValues.spacing / 4),
          const TipsStatsWidget(),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
