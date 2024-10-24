import 'package:applovin_max/applovin_max.dart';
import 'package:flutter/material.dart';

import '../../../keys/keys.dart';

class ApplovinMRecAd extends StatefulWidget {
  const ApplovinMRecAd({super.key});

  @override
  State<ApplovinMRecAd> createState() => _ApplovinMRecAdState();
}

class _ApplovinMRecAdState extends State<ApplovinMRecAd> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SafeArea(
        child: SizedBox(
          width: 300,
          height: 250,
          child: MaxAdView(
            adUnitId: Keys.applovinMrecId,
            adFormat: AdFormat.mrec,
            listener: AdViewAdListener(
              onAdLoadedCallback: (ad) {
                debugPrint('MREC ad onAdLoadedCallback - $ad');
              },
              onAdLoadFailedCallback: (adUnitId, error) {
                debugPrint('MREC ad onAdLoadFailedCallback - $adUnitId - $error');
              },
              onAdClickedCallback: (ad) {
                debugPrint('MREC ad onAdClickedCallback - $ad');
              },
              onAdExpandedCallback: (ad) {
                debugPrint('MREC ad onAdExpandedCallback - $ad');
              },
              onAdCollapsedCallback: (ad) {
                debugPrint('MREC ad onAdCollapsedCallback - $ad');
              },
            ),
          ),
        ),
      ),
    );
  }
}
