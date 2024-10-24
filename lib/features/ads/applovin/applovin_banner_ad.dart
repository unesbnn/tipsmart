import 'package:applovin_max/applovin_max.dart';
import 'package:flutter/material.dart';

import '../../../keys/keys.dart';

class ApplovinBannerAd extends StatelessWidget {
  const ApplovinBannerAd({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: MaxAdView(
          adUnitId: Keys.applovinBannerId,
          adFormat: AdFormat.banner,
          listener: AdViewAdListener(
            onAdLoadedCallback: (ad) {
              debugPrint('Banner ad onAdLoadedCallback - $ad');
            },
            onAdLoadFailedCallback: (adUnitId, error) {
              debugPrint('Banner ad onAdLoadFailedCallback - $adUnitId - $error');
            },
            onAdClickedCallback: (ad) {
              debugPrint('Banner ad onAdClickedCallback - $ad');
            },
            onAdExpandedCallback: (ad) {
              debugPrint('Banner ad onAdExpandedCallback - $ad');
            },
            onAdCollapsedCallback: (ad) {
              debugPrint('Banner ad onAdCollapsedCallback - $ad');
            },
          ),
        ),
      ),
    );
  }
}
